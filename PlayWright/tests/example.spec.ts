import { test, expect } from '@playwright/test';
import { setupTestEnvironment } from '../utils/testSetUp.js';
import { TestGlobalData } from "../Interface/statcDataContainer";
import { ApplicantData } from "../Interface/interface.js";

test('Handle autocomplete dropdown', async ({page}) => {
 
  const { flowControl, lenderSelection, lender } = setupTestEnvironment(); 
  const applicant: ApplicantData = TestGlobalData.applicantData;
        
        // Retrieve coApplicant data safely (it might be null)
        const coApplicant: ApplicantData | null = TestGlobalData.coApplicantData;

        console.log('Applicant Data:', applicant);
 
});