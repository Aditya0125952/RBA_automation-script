// --- Interfaces ---
export interface DecisionModalConfig {
  title: string;
  message: string;
  options?: string[];
  dropdownLabel?: string;
  loanId?: string; // ✅ NEW
  timeoutMs?: number;
  continueText?: string;
  cancelText?: string;
}

export type ModalAction =
  | { action: 'continue'; value?: string }
  | { action: 'cancel'; url: string; timedOut?: boolean };

// --- Main Function ---
export async function showDecisionModal(
  page: any,
  config: DecisionModalConfig
): Promise<ModalAction> {
  return await page.evaluate((cfg) => {
    return new Promise((resolve) => {

      /* ------------------ CLEANUP ------------------ */
      document.getElementById('automation-decision-modal-root')?.remove();

      /* ------------------ THEME ------------------ */
      const theme = {
        gradient:
          'linear-gradient(135deg, #6366F1 0%, #8B5CF6 50%, #EC4899 100%)',
        glassBg: 'rgba(255,255,255,0.85)',
        border: 'rgba(255,255,255,0.4)',
        textDark: '#111827',
        textMedium: '#4B5563',
        primary: '#6366F1',
        primaryHover: '#4F46E5',
        footerBg: 'rgba(249,250,251,0.85)',
      };

      /* ------------------ OVERLAY ------------------ */
      const overlay = document.createElement('div');
      overlay.id = 'automation-decision-modal-root';
      overlay.style.cssText = `
        position: fixed;
        inset: 0;
        background: rgba(17,24,39,0.65);
        backdrop-filter: blur(10px);
        z-index: 2147483647;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 24px;
        opacity: 0;
        transition: opacity 0.25s ease;
      `;

      /* ------------------ MODAL ------------------ */
      const modal = document.createElement('div');
      modal.style.cssText = `
        width: 100%;
        max-width: 520px;
        border-radius: 20px;
        background: ${theme.glassBg};
        backdrop-filter: blur(20px) saturate(180%);
        border: 1px solid ${theme.border};
        box-shadow:
          0 30px 60px -20px rgba(0,0,0,0.35),
          inset 0 1px 0 rgba(255,255,255,0.6);
        transform: scale(0.95);
        opacity: 0;
        transition: all 0.3s cubic-bezier(0.16,1,0.3,1);
        font-family: Inter, -apple-system, BlinkMacSystemFont,
          "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        overflow: visible;
      `;

      /* ------------------ HTML + CSS ------------------ */
      modal.innerHTML = `
        <style>
          .adm-header {
            background: ${theme.gradient};
            padding: 28px;
            border-radius: 20px 20px 0 0;
            color: white;
          }

          /* ---------- TIMER ---------- */
          .adm-timer {
            margin: 4px 0 16px 0;
            font-size: 14px;
            font-weight: 600;
            color: #DC2626;
          }


          .adm-title {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
          }

          .adm-body {
            padding: 28px;
          }

          .adm-message {
            margin: 0 0 20px 0;
            font-size: 15px;
            line-height: 1.7;
            color: ${theme.textMedium};
            white-space: pre-line;
          }

          /* ---------- LOAN ID ---------- */
          .adm-loan {
            margin-bottom: 24px;
          }

          .adm-loan-label {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            color: #6B7280;
            margin-bottom: 6px;
            display: block;
          }

          .adm-loan-box {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            background: rgba(243,244,246,0.9);
            border-radius: 10px;
            padding: 10px 14px;
          }

          .adm-loan-box code {
            font-size: 14px;
            color: ${theme.textDark};
            user-select: all;
          }

          .adm-copy-btn {
            background: ${theme.primary};
            color: white;
            border: none;
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 12px;
            cursor: pointer;
          }

          .adm-copy-btn:hover {
            background: ${theme.primaryHover};
          }

          /* ---------- DROPDOWN ---------- */
          .adm-form-group {
            margin-top: 20px;
          }

          .adm-label {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
          }

          .adm-custom-select {
            position: relative;
          }

          .adm-select-trigger {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid ${theme.primary};
            background: #fff;
            cursor: pointer;
          }

          .adm-trigger-arrow {
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 5px solid ${theme.primary};
          }

          .adm-select-options {
            position: absolute;
            top: calc(100% + 8px);
            left: 0;
            right: 0;
            background: #fff;
            border-radius: 10px;
            border: 1px solid #E5E7EB;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            z-index: 9999;
            max-height: 220px;
            overflow-y: auto;
            overscroll-behavior: contain;
            list-style: none;
            margin: 0;
            padding: 6px 0;
            display: none;
          }

          .adm-select-options.open {
            display: block;
          }

          .adm-option {
            padding: 10px 16px;
            cursor: pointer;
          }

          .adm-option:hover,
          .adm-option.selected {
            background: rgba(99,102,241,0.1);
            color: ${theme.primary};
          }

          /* ---------- FOOTER ---------- */
          .adm-footer {
            background: ${theme.footerBg};
            padding: 18px 28px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid rgba(0,0,0,0.05);
            border-radius: 0 0 20px 20px;
          }

          .adm-btn {
            padding: 10px 22px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
          }

          .adm-btn-cancel {
            background: #fff;
            border: 1px solid rgba(0,0,0,0.1);
          }

          .adm-btn-primary {
            background: ${theme.primary};
            color: white;
            border: none;
          }
        </style>

        <div class="adm-header">
          <h3 class="adm-title">${cfg.title}</h3>
        </div>

        <div class="adm-body">
          <p class="adm-message">${cfg.message}</p>
          <p id="admTimer" class="adm-timer"></p>
          ${
            cfg.loanId
              ? `
            <div class="adm-loan">
              <span class="adm-loan-label">Loan ID</span>
              <div class="adm-loan-box">
                <code id="loanIdText">${cfg.loanId}</code>
                <button id="copyLoanIdBtn" class="adm-copy-btn">Copy</button>
              </div>
            </div>
          `
              : ''
          }

          ${
            cfg.options
              ? `
            <div class="adm-form-group">
              <label class="adm-label">${cfg.dropdownLabel || 'Select Action'}</label>
              <div class="adm-custom-select" id="admCustomSelect">
                <input type="hidden" id="decisionSelectValue" value="${cfg.options[0]}" />
                <div class="adm-select-trigger">
                  <span id="selectedText">${cfg.options[0]}</span>
                  <div class="adm-trigger-arrow"></div>
                </div>
                <ul class="adm-select-options">
                  ${cfg.options
                    .map(
                      (o, i) =>
                        `<li class="adm-option ${
                          i === 0 ? 'selected' : ''
                        }" data-value="${o}">${o}</li>`
                    )
                    .join('')}
                </ul>
              </div>
            </div>
          `
              : ''
          }
        </div>

        <div class="adm-footer">
          <button id="cancelBtn" class="adm-btn adm-btn-cancel">
            ${cfg.cancelText || 'Cancel'}
          </button>
          <button id="continueBtn" class="adm-btn adm-btn-primary">
            ${cfg.continueText || 'Continue'}
          </button>
        </div>
      `;

      overlay.appendChild(modal);
      document.body.appendChild(overlay);

      /* ------------------ ANIMATE IN ------------------ */
      requestAnimationFrame(() => {
        overlay.style.opacity = '1';
        modal.style.opacity = '1';
        modal.style.transform = 'scale(1)';
      });

      /* ------------------ COPY LOAN ID ------------------ */
      if (cfg.loanId) {
  const btn = document.getElementById('copyLoanIdBtn') as HTMLButtonElement;
  const text = document.getElementById('loanIdText')!.textContent!;

  const copyTextToClipboard = (value: string) => {
    const textarea = document.createElement('textarea');
    textarea.value = value;

    // Prevent page jump / visual glitch
    textarea.style.position = 'fixed';
    textarea.style.top = '0';
    textarea.style.left = '0';
    textarea.style.opacity = '0';

    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();

    try {
      document.execCommand('copy');
      btn.textContent = 'Copied';
    } catch (err) {
      console.error('Copy failed', err);
      btn.textContent = 'Failed';
    }

    setTimeout(() => {
      btn.textContent = 'Copy';
    }, 1500);

    document.body.removeChild(textarea);
  };

  btn.onclick = () => copyTextToClipboard(text);
}

      /* ------------------ TIMER ------------------ */
let remaining = 10; // default 10s
const timerEl = document.getElementById('admTimer');
let timerInterval: any;

if (timerEl) {
  timerEl.textContent = `Auto cancelling in ${remaining}s`;

  timerInterval = setInterval(() => {
    remaining--;
    timerEl.textContent = `Auto cancelling in ${remaining}s`;

    if (remaining <= 0) {
      clearInterval(timerInterval);
      cleanup({ action: 'cancel', url: window.location.href, timedOut: true });
    }
  }, 1000);
}


      /* ------------------ DROPDOWN LOGIC ------------------ */
      if (cfg.options) {
        const select = document.getElementById('admCustomSelect')!;
        const trigger = select.querySelector('.adm-select-trigger')!;
        const list = select.querySelector('.adm-select-options')!;
        const hidden = document.getElementById('decisionSelectValue') as HTMLInputElement;
        const selectedText = document.getElementById('selectedText')!;
        const options = select.querySelectorAll('.adm-option');

        trigger.onclick = (e) => {
          e.stopPropagation();
          list.classList.toggle('open');
        };

        options.forEach((opt) => {
          opt.addEventListener('click', () => {
            options.forEach(o => o.classList.remove('selected'));
            opt.classList.add('selected');
            hidden.value = opt.getAttribute('data-value')!;
            selectedText.textContent = opt.textContent!;
            list.classList.remove('open');
          });
        });

        document.addEventListener('click', () => list.classList.remove('open'));
      }

      /* ------------------ CLEANUP ------------------ */
      const cleanup = (result: any) => {
  if (timerInterval) clearInterval(timerInterval);
  overlay.style.opacity = '0';
  modal.style.opacity = '0';
  modal.style.transform = 'scale(0.95)';
  setTimeout(() => {
    overlay.remove();
    resolve(result);
  }, 200);
};


      document.getElementById('continueBtn')!.onclick = () => {
        const input = document.getElementById('decisionSelectValue') as HTMLInputElement;
        cleanup({ action: 'continue', value: cfg.options ? input?.value : undefined });
      };

      document.getElementById('cancelBtn')!.onclick = () => {
        cleanup({ action: 'cancel', url: window.location.href });
      };
    });
  }, config);
}