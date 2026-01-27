import { TestGlobalData } from '../Interface/statcDataContainer';
import UserPool from '../TestScenario/userpool.json';
import { ApplicantData } from '../Interface/interface.js';
import {
  TestCaseControl,
  FlowControl,
  LenderSelection,
  LenderControl,
} from '../Interface/TestInterface.js';

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

  // ---------- STORE GLOBALLY ----------

  // ================= FE OVERRIDE INJECTION =================
const feRaw = process.env.FE_DATA;

if (feRaw) {
  console.log("🟢 FE override detected — decoding Base64");

  let feData: any = null;

  try {
    const decoded = Buffer.from(feRaw, 'base64').toString('utf-8');
    feData = JSON.parse(decoded);

    console.log("📦 DECODED FE DATA:", feData);
  } catch (err) {
    console.log("❌ FE_DATA decode/parse failed:", feRaw);
  }

  const keyMap: Record<string, string> = {
    email: "Email"
  };

  if (feData?.applicantOverrides) {
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
  };
}
