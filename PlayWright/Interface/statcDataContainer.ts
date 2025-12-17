// TestGlobalData.ts (Located in the root folder)

import { ApplicantData } from "../Interface/interface.js"; // Relative path to interfaces/
import { TestCaseControl } from "../Interface/TestInterface.js"; // Relative path to interfaces/

export class TestGlobalData {
    private static _applicantData: ApplicantData | null = null;
    private static _coApplicantData: ApplicantData | null = null; // ADDED
    private static _testControl: TestCaseControl | null = null;
    
    // --- Applicant Data Methods ---
    public static setApplicantData(data: ApplicantData): void {
        TestGlobalData._applicantData = data;
    }
    public static get applicantData(): ApplicantData {
        if (!TestGlobalData._applicantData) {
            throw new Error("Applicant data not set.");
        }
        return TestGlobalData._applicantData;
    }

    // --- Co-Applicant Data Methods --- (NEW)
    public static setCoApplicantData(data: ApplicantData | null): void {
        TestGlobalData._coApplicantData = data;
    }
    public static get coApplicantData(): ApplicantData | null {
        return TestGlobalData._coApplicantData;
    }
    
    // --- Scenario Control Methods ---
    public static setTestControl(control: TestCaseControl): void {
        TestGlobalData._testControl = control;
    }
    public static get testControl(): TestCaseControl {
        if (!TestGlobalData._testControl) {
            throw new Error("Test Control data not set.");
        }
        return TestGlobalData._testControl;
    }
}