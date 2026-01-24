import { Page } from '@playwright/test';
import { TilaStrategy } from './TilaStrategy';
import { GICU_TILA } from '../Lenders/GICU_TILA';
import { PCU_TILA } from '../Lenders/PCU_TILA';
import {LENDER_NAME_MAP} from '../Interface/LenderMapping';
import { PP_TILA } from '../Lenders/PP_TILA';

export class TilaStrategyResolver {
    static resolve(lenderName: string, page: Page): TilaStrategy {
        console.log(`🔍 Resolving TILA strategy for lender input: "${lenderName}"`);

        // 2️⃣ FIND THE KEY IN THE MAP
        // We look through the map entries to find the key whose array contains the lenderName.
        const mappedKey = Object.keys(LENDER_NAME_MAP).find(key =>
            LENDER_NAME_MAP[key].includes(lenderName)
        );

        console.log(`-> Mapped to internal key: "${mappedKey}"`);

        // 3️⃣ SWITCH BASED ON THE FOUND KEY
        switch (mappedKey) {
            case "GICU":
                return new GICU_TILA(page);
            case "PCU":
                return new PCU_TILA(page);
            case "PP":
                return new PP_TILA(page);
            default:
                // Handle cases where the name isn't in your map yet.
                // For now, based on your old code, you were defaulting to PCU.
                console.warn(`⚠️ Unknown lender or no mapping found. Defaulting to PCU strategy.`);
                return new PCU_TILA(page);
        }
    }
}