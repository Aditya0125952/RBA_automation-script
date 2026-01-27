import { TestGlobalData } from '../Interface/statcDataContainer';
import UserPool from '../TestScenario/userpool.json';
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

// ---------------- USER NORMALIZATION ----------------
// Converts OLD JSON structure → new lowercase model
function normalizeApplicant(user: any) {
  return {
    email: user.email || user.Email,
  };
}

// ---------------- USER RESOLVER ----------------
function resolveUserKey(
  role: 'applicant' | 'coApplicant',
  scenario: TestCaseControl,
  users: Record<string, any>
): string {
  const lender = scenario.lender?.name;
  const isSpecialLender =
    lender === 'GoodLeap' || lender === 'Upgrade';

  const explicitKey =
    role === 'applicant'
      ? scenario.Applicant_Test_Data
      : scenario.Co_Applicant_Test_Data;

  if (explicitKey?.trim()) {
    console.log(`Using explicit ${role}: ${explicitKey}`);
    return explicitKey.trim();
  }

  if (isSpecialLender) {
    const pool = Object.entries(users).filter(
      ([_, u]) => u.supportedLenders?.includes(lender)
    );

    if (!pool.length) {
      throw new Error(`No ${role} users found for lender ${lender}`);
    }

    const [key] = pool[Math.floor(Math.random() * pool.length)];
    console.log(`Randomly selected ${role} '${key}' for ${lender}`);
    return key;
  }

  return role === 'applicant' ? 'Ana_Villar' : 'Morgan_Blake';
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

  console.log(`\n--- Starting Scenario: ${scenario.scenarioName} ---`);

  // ---------- APPLICANT ----------
  const applicantKey = resolveUserKey('applicant', scenario, UserPool.Users);
  const applicantBase = normalizeApplicant(UserPool.Users[applicantKey]);

  let applicantFinal = safeMergeData(
    applicantBase,
    scenario.applicantOverrides
  );

  // ---------- CO-APPLICANT ----------
  let coApplicantFinal: any = null;

  if (scenario.flowControl.hasCoApplicant) {
    const coKey = resolveUserKey('coApplicant', scenario, UserPool.Users);
    const coBase = normalizeApplicant(UserPool.Users[coKey]);

    coApplicantFinal = safeMergeData(
      coBase,
      scenario.coApplicantOverrides
    );
  }

  // ================= FE OVERRIDE INJECTION =================
  const feRaw = process.env.FE_DATA;

  if (feRaw) {
    console.log("🟢 FE override detected — decoding Base64");

    try {
      const decoded = Buffer.from(feRaw, 'base64').toString('utf-8');
      const feData = JSON.parse(decoded);

      console.log("📦 DECODED FE DATA:", feData);

      const keyMap: Record<string, string> = {
        email: "email"
      };

      if (feData?.applicantOverrides) {
        Object.keys(feData.applicantOverrides).forEach(feKey => {
          const mappedKey = keyMap[feKey];
          const value = feData.applicantOverrides[feKey];

          if (mappedKey && value) {
            console.log(`✏️ FE override → ${mappedKey}:`, value);
            (applicantFinal as any)[mappedKey] = value;
          }
        });
      }

    } catch (err) {
      console.log("❌ FE_DATA decode/parse failed:", feRaw);
    }
  } else {
    console.log("🟡 Running in local mode (no FE override)");
  }

  console.log("📧 FINAL EMAIL USED:", applicantFinal.email);

  // ---------- STORE GLOBALLY ----------
  TestGlobalData.setApplicantData(applicantFinal);
  TestGlobalData.setCoApplicantData(coApplicantFinal);
  TestGlobalData.setTestControl(scenario);

  return {
    flowControl: scenario.flowControl,
    lenderSelection: scenario.lenderSelection,
    lender: scenario.lender,
  };
}
