// interfaces/testCaseInterfaces.ts (New/Updated File)
import {UserKeys} from "./dataNames.js";

export interface LenderControl {
    name: string;
    state: string;
    Zip: string;
}

export interface FlowControl {
    hasCoApplicant: boolean;
    kbaAnswersNeeded: boolean;
    creditFreeze: boolean;
}

export interface LenderSelection {
    merchant: string;
    dcPlan: string;
    requested_amount: string;
    deposite_amount: string;
}

export interface TestCaseControl {
    scenarioName: string;
    applicant_key : string;
    Co_Applicant_key : string;
    flowControl: FlowControl;
    lenderSelection: LenderSelection;
    lender: LenderControl;
}