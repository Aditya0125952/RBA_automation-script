// Assuming this code is in your utility file (e.g., utils/testSetUp.js or TS_TestSetUp.ts)

import { TestGlobalData } from '../Interface/statcDataContainer';
import * as UserPool from '../TestScenario/userpool.json';
import * as TestScenario from '../TestScenario/test.json'; // The raw scenario file
import { ApplicantData } from '../Interface/interface.js';
import { TestCaseControl, FlowControl, LenderSelection, LenderControl } from '../Interface/TestInterface.js'; // Ensure all interfaces are imported

// --- External Utility Function (Required for Safe Merging) ---
// IMPORTANT: This function must be defined or imported alongside this setup function.
function safeMergeData<T extends object>(defaultData: T, overrideData: Partial<T> | undefined): T {
    if (!overrideData) {
        return defaultData;
    }

    const mergedData: T = { ...defaultData };

    for (const key in overrideData) {
        if (overrideData.hasOwnProperty(key)) {
            const overrideValue = overrideData[key] as T[keyof T];

            // CRITICAL CHECK: Only apply the override if it has a valid, non-empty value
            if (overrideValue !== null && overrideValue !== undefined && overrideValue !== "") {
                mergedData[key] = overrideValue;
            }
        }
    }
    return mergedData;
}
// -----------------------------------------------------------


// Define the FINAL, structured return type
export interface ITestSetupData {
    flowControl: FlowControl;
    lenderSelection: LenderSelection;
    lender: LenderControl;
    // Assuming you will add loginCredentials to your test.json later:
    // loginCredentials: { username: string, password: string }; 
}


export function setupTestEnvironment(): ITestSetupData {
    
    console.log('--- Starting Test Context Setup ---');
    
    // 1. Load Raw Data
    const controlData: TestCaseControl = TestScenario as TestCaseControl;
    const defaultApplicant: ApplicantData = UserPool.Users[0] as ApplicantData; 
    // Assuming default Co-Applicant data is available at index 1 (or is null/undefined)
    const defaultCoApplicant: ApplicantData | null = UserPool.Users[1] as ApplicantData || null; 

    // --- CORE DATA MERGE AND HANDLING ---

    // 2. A. APPLICANT SAFE MERGE (Defaults + Overrides)
    const finalApplicantData: ApplicantData = safeMergeData(
        defaultApplicant, 
        controlData.applicantOverrides 
    );

    let finalCoApplicantData: ApplicantData | null = null;
    
    // 2. B. CO-APPLICANT CONDITIONAL SAFE MERGE
    if (controlData.flowControl.hasCoApplicant) {
        if (!defaultCoApplicant) {
             console.error("ERROR: hasCoApplicant is true, but no default co-applicant data found in userpool.json at index 1.");
             // Proceed with null data to fail gracefully
        } else {
            // Merge default co-applicant data with any scenario-specific overrides
            finalCoApplicantData = safeMergeData(
                defaultCoApplicant,
                controlData.coApplicantOverrides
            );
        }
    }

    // 3. STATIC DATA INJECTION: Inject the final, merged data
    TestGlobalData.setApplicantData(finalApplicantData);
    TestGlobalData.setCoApplicantData(finalCoApplicantData); // Requires TestGlobalData to have this method
    TestGlobalData.setTestControl(controlData); 
    
    // Optional: Call modifications (e.g., unique email generation)
    // GlobalTestContext.applyFlowModifications(); 

    // 4. Return the required flow variables
    return {
        flowControl: controlData.flowControl,
        lenderSelection: controlData.lenderSelection,
        lender: controlData.lender,
        // loginCredentials: controlData.loginCredentials // Include this when you add it to JSON
    };
}