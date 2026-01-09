// --- Interfaces (Ensure these are defined in your project) ---
export interface DecisionModalConfig {
  title: string;
  message: string;
  options?: string[];
  dropdownLabel?: string;
  continueText?: string;
  cancelText?: string;
}

export type ModalAction =
  | { action: 'continue'; value?: string }
  | { action: 'cancel'; url: string };


// --- The Main Function ---
export async function showDecisionModal(
  page: any, // Using 'any' for generic Playwright Page type compatibility
  config: DecisionModalConfig
): Promise<ModalAction> {
  return await page.evaluate((cfg) => {
    return new Promise((resolve) => {
      // 1. Cleanup any existing modals first
      document.getElementById('automation-decision-modal-root')?.remove();

      // 2. Define Theme Colors (Indigo/Purple Palette)
      const theme = {
        primary: '#4F46E5',     // Indigo 600 (Buttons, accents)
        primaryHover: '#4338CA', // Indigo 700 (Button hover)
        primaryLight: '#EEF2FF', // Indigo 50 (Icon background, hover state)
        textDark: '#111827',    // Gray 900 (Title)
        textMedium: '#4B5563',  // Gray 600 (Body text)
        border: '#E5E7EB',      // Gray 200 (Borders)
        bgHover: '#F9FAFB',     // Gray 50 (Footer background)
      };

      /* ---------- Create Overlay (Background Blur) ---------- */
      const overlay = document.createElement('div');
      overlay.id = 'automation-decision-modal-root';
      overlay.style.cssText = `
        position: fixed;
        inset: 0;
        background-color: rgba(17, 24, 39, 0.65);
        backdrop-filter: blur(8px);
        z-index: 2147483647;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        opacity: 0;
        transition: opacity 0.2s ease-out;
      `;

      /* ---------- Create Modal Container ---------- */
      const modal = document.createElement('div');
      modal.style.cssText = `
        background: #ffffff;
        padding: 0;
        border-radius: 16px;
        width: 100%;
        max-width: 480px;
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25), 0 0 0 1px rgba(0,0,0,0.05);
        transform: scale(0.95);
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        position: relative; /* For dropdown positioning */
      `;

      /* ---------- Inject HTML & CSS ---------- */
      modal.innerHTML = `
        <style>
          .adm-content-wrapper { padding: 32px; }

          /* Header & Icon */
          .adm-header { display: flex; align-items: flex-start; gap: 16px; margin-bottom: 20px; }
          .adm-icon-badge {
            flex-shrink: 0; width: 40px; height: 40px;
            background-color: ${theme.primaryLight};
            color: ${theme.primary};
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
          }
          .adm-icon-badge svg { width: 24px; height: 24px; stroke-width: 2; }
          .adm-title { margin: 0; font-size: 20px; font-weight: 700; color: ${theme.textDark}; line-height: 1.2; }
          .adm-message { font-size: 15px; color: ${theme.textMedium}; line-height: 1.6; margin: 0 0 24px 0; padding-left: 56px; }

          /* Form & Custom Dropdown CSS */
          .adm-form-group { padding-left: 56px; margin-bottom: 24px; }
          .adm-label { font-size: 13px; font-weight: 600; color: ${theme.textDark}; margin-bottom: 8px; display: block; text-transform: uppercase; letter-spacing: 0.05em; }
          
          /* Custom Select Container */
          .adm-custom-select { position: relative; width: 100%; }

          /* The trigger button (looks like the input box) */
          .adm-select-trigger {
            display: flex; justify-content: space-between; align-items: center;
            width: 100%; padding: 12px 16px;
            border-radius: 8px; border: 1px solid ${theme.primary};
            font-size: 15px; color: ${theme.textDark}; background: #fff;
            cursor: pointer; transition: all 0.15s ease;
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
          }
          .adm-select-trigger:focus { outline: none; box-shadow: 0 0 0 4px ${theme.primaryLight}; }

          /* Custom Arrow */
          .adm-trigger-arrow {
            width: 0; height: 0;
            border-left: 5px solid transparent; border-right: 5px solid transparent;
            border-top: 5px solid ${theme.primary}; margin-left: 10px;
          }

          /* The beautiful dropdown list */
          .adm-select-options {
            position: absolute; top: calc(100% + 8px); left: 0; right: 0;
            background: #fff; border-radius: 8px;
            border: 1px solid ${theme.border};
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            z-index: 20; max-height: 220px; overflow-y: auto;
            list-style: none; padding: 4px 0; margin: 0;
            display: none; /* Hidden by default */
            opacity: 0; transform: translateY(-10px); transition: all 0.2s ease-out;
          }
          /* State to show the list */
          .adm-select-options.open { display: block; opacity: 1; transform: translateY(0); }

          /* Individual options */
          .adm-option {
            padding: 10px 16px; font-size: 15px; color: ${theme.textDark};
            cursor: pointer; transition: background-color 0.1s ease;
            border-radius: 4px; margin: 0 4px;
          }
          .adm-option:hover { background-color: ${theme.primaryLight}; color: ${theme.primary}; }
          .adm-option.selected { font-weight: 500; background-color: ${theme.primaryLight}; color: ${theme.primary}; }

          /* Footer & Buttons */
          .adm-footer {
            background-color: ${theme.bgHover}; padding: 16px 32px;
            display: flex; justify-content: flex-end; gap: 12px;
            border-top: 1px solid ${theme.border}; border-radius: 0 0 16px 16px;
          }
          .adm-btn {
            padding: 10px 20px; font-size: 14px; font-weight: 600;
            border-radius: 8px; cursor: pointer; transition: all 0.2s ease;
          }
          .adm-btn-cancel {
            background: #fff; color: ${theme.textDark}; border: 1px solid ${theme.border};
            box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
          }
          .adm-btn-cancel:hover { background: ${theme.bgHover}; border-color: #D1D5DB; }
          .adm-btn-primary {
            background: ${theme.primary}; color: white; border: 1px solid transparent;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
          }
          .adm-btn-primary:hover { background: ${theme.primaryHover}; transform: translateY(-1px); }
        </style>

        <div class="adm-content-wrapper">
          <div class="adm-header">
            <div class="adm-icon-badge">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="18" height="18" rx="4" />
                <circle cx="9" cy="10" r="2" />
                <circle cx="15" cy="10" r="2" />
                <path d="M8 16h8" />
                <line x1="12" y1="1" x2="12" y2="3" />
              </svg>
            </div>
            <div><h3 class="adm-title">${cfg.title}</h3></div>
          </div>

          <p class="adm-message">${cfg.message}</p>

          ${cfg.options ? `
            <div class="adm-form-group">
                <label class="adm-label">${cfg.dropdownLabel || 'Select Required Action'}</label>
                
                <div class="adm-custom-select" id="admCustomSelect">
                    <input type="hidden" id="decisionSelectValue" value="${cfg.options[0]}">
                    
                    <div class="adm-select-trigger" tabindex="0">
                        <span id="selectedText">${cfg.options[0]}</span>
                        <div class="adm-trigger-arrow"></div>
                    </div>
                    
                    <ul class="adm-select-options">
                        ${cfg.options.map((o, i) => `
                            <li class="adm-option ${i === 0 ? 'selected' : ''}" data-value="${o}">${o}</li>
                        `).join('')}
                    </ul>
                </div>
            </div>
            ` : ''}
        </div>

        <div class="adm-footer">
          <button id="cancelBtn" class="adm-btn adm-btn-cancel">${cfg.cancelText || 'Stop & Cancel'}</button>
          <button id="continueBtn" class="adm-btn adm-btn-primary">${cfg.continueText || 'Confirm & Continue'}</button>
        </div>
      `;

      overlay.appendChild(modal);
      document.body.appendChild(overlay);

      // 3. Trigger Enter Animation
      requestAnimationFrame(() => {
        overlay.style.opacity = '1';
        modal.style.opacity = '1';
        modal.style.transform = 'scale(1)';
      });

      // ----- Custom Dropdown Logic -----
      if (cfg.options) {
        const customSelect = document.getElementById('admCustomSelect')!;
        const trigger = customSelect.querySelector('.adm-select-trigger') as HTMLElement;
        const optionsList = customSelect.querySelector('.adm-select-options') as HTMLElement;
        const hiddenInput = document.getElementById('decisionSelectValue') as HTMLInputElement;
        const selectedTextSpan = document.getElementById('selectedText')!;
        const options = customSelect.querySelectorAll('.adm-option');

        // Toggle open/close on trigger click
        trigger.addEventListener('click', (e) => {
            e.stopPropagation(); // Prevent immediate close by document listener
            optionsList.classList.toggle('open');
        });

        // Handle option selection
        options.forEach(option => {
            option.addEventListener('click', (e) => {
                e.stopPropagation();
                const value = option.getAttribute('data-value')!;
                const text = option.textContent!;

                // Update state
                hiddenInput.value = value;
                selectedTextSpan.textContent = text;

                // Update visual selection state
                options.forEach(o => o.classList.remove('selected'));
                option.classList.add('selected');

                // Close dropdown
                optionsList.classList.remove('open');
            });
        });

        // Close dropdown if clicking outside of it
        document.addEventListener('click', (e) => {
            if (!customSelect.contains(e.target as Node)) {
                optionsList.classList.remove('open');
            }
        });
      }
      // ----------------------------------


      // 4. Helper function for exit animation and resolution
      const cleanupAndResolve = (result: any) => {
        overlay.style.opacity = '0';
        modal.style.opacity = '0';
        modal.style.transform = 'scale(0.95)';
        setTimeout(() => { overlay.remove(); resolve(result); }, 200);
      }

      // 5. Attach Button Event Listeners
      document.getElementById('continueBtn')!.onclick = () => {
        // Read value from the hidden input
        const hiddenInput = document.getElementById('decisionSelectValue') as HTMLInputElement;
        const value = cfg.options && hiddenInput ? hiddenInput.value : undefined;
        cleanupAndResolve({ action: 'continue', value });
      };

      document.getElementById('cancelBtn')!.onclick = () => {
        cleanupAndResolve({ action: 'cancel', url: window.location.href });
      };
    });
  }, config);
}