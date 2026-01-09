import { BasePage } from "../../BasePage.page";

export interface TilaStrategy {
  sign(): Promise<void>;
}