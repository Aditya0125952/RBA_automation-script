import { ApplicantData } from "../Interface/interface.js";
import { TestCaseControl } from "../Interface/TestInterface.js";

export class TestGlobalData {
  // 🔒 PRIVATE STORAGE (underscore!)
  private static _applicant: ApplicantData | null = null;
  private static _coApplicant: ApplicantData | null = null;
  private static _testControl: TestCaseControl | null = null;

  // ================= SETTERS =================

  static setApplicantData(data: ApplicantData): void {
    this._applicant = data;
  }

  static setCoApplicantData(data: ApplicantData | null): void {
    this._coApplicant = data;
  }

  static setTestControl(control: TestCaseControl): void {
    this._testControl = control;
  }

  // ================= GETTERS =================

  static get applicantData(): ApplicantData {
    if (!this._applicant) {
      throw new Error("Applicant data not initialized");
    }
    return this._applicant;
  }

  static get coApplicantData(): ApplicantData | null {
    return this._coApplicant;
  }

  static getUser(role: "applicant" | "coApplicant"): ApplicantData {
    const user =
      role === "applicant" ? this._applicant : this._coApplicant;

    if (!user) {
      throw new Error(`${role} data not available`);
    }
    return user;
  }

  static get testControl(): TestCaseControl {
    if (!this._testControl) {
      throw new Error("Test control not initialized");
    }
    return this._testControl;
  }
    
  // ================= DEBUG =================
  static debug(): void {
    console.log("====== TestGlobalData DEBUG ======");
    console.log("Applicant:", this._applicant);
    console.log("Co-Applicant:", this._coApplicant);
    console.log("Test Control:", this._testControl);
    console.log("=================================");
  }

  // ================= RESET (OPTIONAL) =================
  static reset(): void {
    this._applicant = null;
    this._coApplicant = null;
    this._testControl = null;
  }
}
