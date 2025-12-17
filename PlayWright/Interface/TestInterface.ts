// interfaces/testCaseInterfaces.ts (New/Updated File)

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
}

export interface TestCaseControl {
    scenarioName: string;
    flowControl: FlowControl;
    lenderSelection: LenderSelection;
    lender: LenderControl;
}