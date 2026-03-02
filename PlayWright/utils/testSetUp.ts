import { TestGlobalData } from '../Interface/statcDataContainer';
import UserPool from '../TestScenario/userpool.json';
import { ApplicantData } from '../Interface/interface.js';
import {
  TestCaseControl,
  FlowControl,
  LenderSelection,
  LenderControl,
  InstanceControl
} from '../Interface/TestInterface.js';
import { Server } from 'http';

// ---------------- SAFE MERGE ----------------
function safeMergeData<T extends object>(
  base: T,
  overrides?: Partial<T>
): T {
  if (!overrides) return base;
  const merged = { ...base } as T;

  for (const key in overrides) {
    const value = overrides[key];
    if (value !== undefined && value !== null && value !== '') {
      merged[key] = value as T[keyof T];
    }
  }

  return merged;
}




// ---------------- USER RESOLVER ----------------
function resolveUserKey(
  role: 'applicant' | 'coApplicant',
  scenario: TestCaseControl,
  users: Record<string, ApplicantData>
): string {
  const lender = scenario.lender?.name;
  const isSpecialLender =
    lender === 'GoodLeap' || lender === 'Upgrade';

  const explicitKey =
    role === 'applicant'
      ? scenario.Applicant_Test_Data
      : scenario.Co_Applicant_Test_Data;

  // 1️⃣ Explicit key always wins
  if (explicitKey?.trim()) {
    console.log(`Using explicit ${role}: ${explicitKey}`);
    return explicitKey.trim();
  }

  // 2️⃣ Special lender → random user
  if (isSpecialLender) {
    const pool = Object.entries(users).filter(
      ([_, u]) => u.supportedLenders?.includes(lender)
    );

    if (!pool.length) {
      throw new Error(
        `No ${role} users found for lender ${lender}`
      );
    }

    const [key] =
      pool[Math.floor(Math.random() * pool.length)];

    console.log(
      `Randomly selected ${role} '${key}' for ${lender}`
    );
    return key;
  }

  // 3️⃣ Default fallback
  return role === 'applicant'
    ? 'Ana_Villar'
    : 'Morgan_Blake';
}

// ---------------- RETURN TYPE ----------------
export interface ITestSetupData {
  flowControl: FlowControl;
  lenderSelection: LenderSelection;
  lender: LenderControl;
  instance: InstanceControl;
}

// ---------------- MAIN SETUP ----------------
export function setupTestEnvironment(
  scenario: TestCaseControl
): ITestSetupData {
  if (!scenario) {
    throw new Error('setupTestEnvironment: scenario is undefined');
  }

  console.log(
    `\n--- Starting Scenario: ${scenario.scenarioName} ---`
  );

  // ---------- APPLICANT ----------
  const applicantKey = resolveUserKey(
    'applicant',
    scenario,
    UserPool.Users
  );

  const applicantBase = UserPool.Users[applicantKey];
  const applicantFinal = safeMergeData(
    applicantBase,
    scenario.applicantOverrides
  );

  // ---------- CO-APPLICANT ----------
  let coApplicantFinal: ApplicantData | null = null;

  if (scenario.flowControl.hasCoApplicant) {
    const coKey = resolveUserKey(
      'coApplicant',
      scenario,
      UserPool.Users
    );

    const coBase = UserPool.Users[coKey];
    coApplicantFinal = safeMergeData(
      coBase,
      scenario.coApplicantOverrides
    );
  }


  // ================= GOODLEAP PHONE OVERRIDE =================
  if (scenario.lender?.name === "GoodLeap") {
      console.log("🛠️ GoodLeap detected: Overriding phone numbers with 888-prefix");
      if (applicantFinal) {
          const dynamicPhone = ssnForGoodLeap();
          const dynamicSSN = SingleapplicantSSN();
          (applicantFinal as any).ssn = dynamicSSN;
          (applicantFinal as any).mobileNumber = dynamicPhone;
          console.log(`📱 Applicant dynamic phone set to: ${dynamicPhone} and ssn : ${dynamicSSN}`);
      }

      if (coApplicantFinal) {
        const dynamicPhoneForCoApp = ssnForGoodLeap();
          (coApplicantFinal as any).mobileNumber = dynamicPhoneForCoApp;
          console.log(`📱 Co-Applicant dynamic phone set to: ${dynamicPhoneForCoApp}`);
      }
  }


  //Upgrade
  if (scenario.lender?.name === "Upgrade") {
    console.log("🛠️ Upgrade detected: Overriding email");
    const currentEmail = (applicantFinal as any).email || (applicantFinal as any).Email;
    if (currentEmail) {
        const finalizedEmail = generateUniqueEmail(currentEmail);
        (applicantFinal as any).email = finalizedEmail;
        (applicantFinal as any).Email = finalizedEmail;
    }
  }


  // ---------- STORE GLOBALLY ----------
// ================= FE OVERRIDE INJECTION =================
const feRaw = process.env.FE_DATA;
let feData: any = null;

if (feRaw) {
  console.log("🟢 FE override detected — decoding Base64");

  try {
    const decoded = Buffer.from(feRaw, 'base64').toString('utf-8');
    feData = JSON.parse(decoded);
    console.log("📦 DECODED FE DATA:", feData);
  } catch (err) {
    console.log("❌ FE_DATA decode/parse failed:", feRaw);
  }

  // ================= APPLICANT OVERRIDE =================
  if (feData?.applicantOverrides) {
    const keyMap: Record<string, string> = {
      email: "Email",
      firstName: "FirstName",
      lastName: "LastName",
      mobile: "mobileNumber",
      street: "street_add",
      city: "city",
      state: "state",
      zip: "zipcode",
      dob: "dob",
      ssn: "ssn"
    };

    Object.keys(feData.applicantOverrides).forEach(feKey => {
      const mappedKey = keyMap[feKey];
      const value = feData.applicantOverrides[feKey];

      if (mappedKey && value) {
        console.log(`✏️ Overriding ${mappedKey} with FE value:`, value);
        (applicantFinal as any)[mappedKey] = value;
      }
    });
  }

  console.log("📧 FINAL EMAIL AFTER FE OVERRIDE:", applicantFinal.Email);

  // ================= LENDER OVERRIDE =================
  if (feData?.lenderSelectionOverrides) {
    console.log("🟢 Applying FE lender overrides");

    const lenderOverrides = feData.lenderSelectionOverrides;

    const lenderKeyMap: Record<string, string> = {
      merchant: "merchant",
      dcPlan: "dcPlan",
      requested_amount: "requested_amount",
      deposite_amount: "deposite_amount"
    };

    Object.keys(lenderOverrides).forEach(feKey => {
      const mappedKey = lenderKeyMap[feKey];
      const value = lenderOverrides[feKey];

      if (mappedKey && value) {
        console.log(`✏️ Overriding lender.${mappedKey} with FE value:`, value);
        (scenario.lenderSelection as any)[mappedKey] = value;
      }
    });

  }


  if (feData?.instanceOverrides) {
    console.log("🟢 Applying FE instance overrides");
    const instanceOverrides = feData.instanceOverrides;
    const instanceKeyMap: Record<string, string> = {
      rba: "rba",
      server: "server",
    };
    Object.keys(instanceOverrides).forEach(feKey => {
      const mappedKey = instanceKeyMap[feKey];
      const value = instanceOverrides[feKey];
      if (mappedKey && value) {
        console.log(`✏️ Overriding instance.${mappedKey} with FE value:`, value);
        (scenario.instance as any)[mappedKey] = value;
      }
    });

    console.log("📦 FINAL INSTANCE AFTER FE OVERRIDE:", scenario.instance);
  }

} else {
  console.log("🟡 Running in local mode (no FE override)");
}


  TestGlobalData.setApplicantData(applicantFinal);
  TestGlobalData.setCoApplicantData(coApplicantFinal);
  TestGlobalData.setTestControl(scenario);

  // ---------- DEBUG ---------- i will use these to check 
  //console.log('Applicant Loaded:', applicantFinal.FirstName);
  //if (coApplicantFinal) {
   // console.log('Co-Applicant Loaded:', coApplicantFinal.FirstName);
  //}

  // ---------- RETURN ----------
  return {
    flowControl: scenario.flowControl,
    lenderSelection: scenario.lenderSelection,
    lender: scenario.lender,
    instance: scenario.instance
  };


function ssnForGoodLeap(): string {
  let randomPart = '';
  for (let i = 0; i < 7; i++) {
    randomPart += Math.floor(Math.random() * 10).toString();
  }
  return `888${randomPart}`;
}

function SingleapplicantSSN(): string{
  const first = Math.floor(Math.random() * 5) + 1; 
  const last = Math.floor(Math.random() * 9) + 1; 
  const ssn = `${first}0010211${last}`;
  console.log(`Generated GL SSN: ${ssn}`);
  return ssn;
}

function generateUniqueEmail(email: string | undefined): string {
  if (!email || typeof email !== 'string') return email || '';
  
  // If the email already has a '+', we skip the modification
  if (email.includes('+')) {
    console.log(`📧 Email already unique: ${email}. Skipping modification.`);
    return email;
  }

  const [name, domain] = email.split('@');
  // Using a 4-digit random number for uniqueness
  const uniqueId = Math.floor(1000 + Math.random() * 9000); 
  const newEmail = `${name}+${uniqueId}@${domain}`;
  
  console.log(`📧 Email transformed: ${email} -> ${newEmail}`);
  return newEmail;
}

}
