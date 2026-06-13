# ACTUM v3 Solana Contract Security Review

Date: 2026-06-13

Style: SlowMist-style contract review

Target: `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam`

Branch state: local dirty worktree on `codex/actum-hk-sql-seam`

## 1. Executive Conclusion

ACTUM v3 Solana is currently a reduced claim/burn settlement kernel, not the full ACTUM white-paper protocol stack.

The reviewed Solana surface can support the current devnet MVP claim/burn lane with evidence. It should not be represented as complete implementation of the latest white paper, because major white-paper capabilities remain off-chain, out of scope, or only partially anchored.

Overall verdict:

- Devnet / tester MVP: conditionally acceptable.
- Claim-only public demo: acceptable if scope is stated clearly.
- Mainnet production: not ready.
- Full white-paper implementation claim: not acceptable.

No direct critical fund-drain issue was found in the inspected claim/burn execution path. The main risks are truth drift, incomplete DTN credential semantics, burn attestation proof strength, and production governance readiness.

## 2. Scope

Reviewed:

- Latest white paper DOCX: `/Users/test/Downloads/ACTUM-Protocol-White-Paper-v3.6-Public (1) (1).docx`
- Current top-level repo truth:
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/README.md`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/artifacts/actum/current/manifest.json`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/artifacts/actum/current/status.json`
- Architecture and settlement docs:
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/docs/actum/ACTUM-SAED.md`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/docs/actum/ACTUM-EXECUTION-PLAN.md`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/docs/actum/ACTUM-SETTLEMENT-SPEC.md`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/docs/actum/ACTUM-V3-ACCEPTANCE-CONTRACT.md`
- Solana program:
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/contracts/solana/programs/actum-v3/src/lib.rs`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/contracts/solana/programs/actum-v3/src/state_machine_tests.rs`
- Shared TS contract and verification surface:
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/contracts/solana/src/*`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/contracts/solana/tests/*`
- Current devnet evidence:
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/artifacts/actum/current/devnet-contract-real-e2e.json`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/artifacts/actum/current/dtn-real-flow-acceptance.json`
  - `/Users/test/project/mdis-platform/.worktrees/actum-hk-sql-seam/artifacts/actum/current/burn-real-flow-acceptance.json`

Out of scope:

- Full HK backend security review
- Full Cayman treasury implementation review
- Mainnet deployment operation review
- Legal, tax, securities, exchange, or token-listing opinion
- Oracle provider correctness beyond contract anchoring behavior

## 3. White-Paper Alignment Judgment

The latest white paper centers on:

- Solana SPL FACT token and smart-contract controls
- POHA event/evidence trail
- DTN account-based credential
- claim/burn settlement
- data-rights separation
- data product, API, Hash Audit Pack, ADC access functions
- governance-conditioned treasury and liquidity policy
- no custody, no internal marketplace, no automatic buyback, no price floor

The current repo truth centers on:

- `devnet-mvp`
- claim-only public devnet MVP passed
- reduced ACTUM v1 surface
- DTN-backed tester E2E as next upgrade
- no DTN metadata update
- no burn cancel
- AZP and user self-service DTN purchase out of active scope

Therefore the correct positioning is:

> ACTUM v3 Solana currently implements a reduced L4 settlement and claim/burn surface for the devnet MVP. It is not a complete on-chain embodiment of the ACTUM v3.6 white paper.

## 4. Positive Security Observations

These controls are currently working or backed by tests/evidence:

- Claimable truth is anchored on Solana batch state and Merkle proof.
- Claim subject is `owner_wallet + period + claim_amount -> leaf_hash`.
- `ClaimReceipt` uses `leaf_hash` as a nullifier, preventing double-claim on the same leaf.
- Claim requires `owner_wallet` signer and an active owner-bound DTN credential.
- Claim destination is the owner wallet ATA through `associated_token::authority = owner_wallet`.
- Claim can only use the latest effective batch for the period.
- Correction before finality is constrained; post-finality replacement is rejected.
- Burn and claim paths are separated.
- Burn execution is treasury-authority gated.
- Burn can only consume vault balance above `reserved_claim_amount`.
- No custody, marketplace, OTC, bid/ask, or auto-buyback path was observed in the Solana program.

Verification performed:

- `cargo test -p actum-v3 -- --nocapture`: 94 passed.
- `npm run actum-v3:shared-contract:test`: 104 passed.
- Current artifacts record passed devnet claim, DTN issue/status, and burn submit/execute flows.

## 5. Findings Summary

| ID | Severity | Title | Status |
|---|---:|---|---|
| ACTUM-SOL-001 | High | Current truth and audit/evidence docs conflict on contract scope | Open |
| ACTUM-SOL-002 | High | On-chain DTN credential is too weak for full white-paper credential semantics | Open |
| ACTUM-SOL-003 | Medium | Burn oracle attestation is an anchor, not on-chain self-verifying evidence | Open |
| ACTUM-SOL-004 | Medium | DTN owner self-custody is not enforced on-chain at issuance | Open / Accepted risk in current docs |
| ACTUM-SOL-005 | Medium | Production governance and treasury readiness are not represented on-chain | Open |
| ACTUM-SOL-006 | Low / Medium | Global claim reserve creates a hot-account throughput bottleneck | Open / MVP acceptable |

## 6. Detailed Findings

### ACTUM-SOL-001: Current Truth And Audit/Evidence Docs Conflict On Contract Scope

Severity: High

Type: Truth split / release-risk / auditability

Evidence:

- Current manifest states the accepted surface is reduced: 11 instructions, no online authority reconfiguration, no DTN metadata update, no burn cancel.
- Current program entrypoints include `initialize`, `configure_claim_vault`, `issue_dtn`, `update_dtn_status`, `submit_batch`, `supersede_batch`, `submit_burn_proposal`, `execute_burn_proposal`, `pause`, `unpause`, `claim_leaf`.
- `ACTUM-V3-EVIDENCE-MATRIX.md` still claims surfaces that are not in the current program, including `update_dtn_metadata`, `cancel_burn_proposal`, metadata hash validation, and on-curve rejection.
- `ACTUM-V3-ACCEPTANCE-CONTRACT.md` still says burn cancellation is required, while current manifest says no burn cancel.

Impact:

This is not a direct fund-drain issue. It is worse at the release layer: reviewers, operators, and external partners may certify the wrong system. A stale evidence matrix can create false pass/fail confidence and make the project appear to have implemented controls that are not actually present.

Recommendation:

- Promote `artifacts/actum/current/manifest.json`, `contracts/solana/programs/actum-v3/README.md`, and current `lib.rs` surface as the active contract truth.
- Regenerate or quarantine stale evidence docs that mention removed surfaces.
- Update the acceptance contract to match the reduced v1 surface, or explicitly label missing items as future gates.
- Do not use stale evidence docs as audit proof until reconciled.

### ACTUM-SOL-002: On-Chain DTN Credential Is Too Weak For Full White-Paper Credential Semantics

Severity: High

Type: Architecture / protocol completeness

Evidence:

- White paper defines DTN as an account-based credential carrying protocol access, utility allocation eligibility, data/evidence product request eligibility, API access eligibility, and ADC participation eligibility.
- Current `DtnCredential` stores only `dtn_id`, `owner_wallet`, `status`, and `expiry_at`.
- Current architecture docs intentionally keep full lifecycle, qualification, tier, entity, and compliance detail in HK registry while Solana keeps only minimal protocol credential existence.

Impact:

The current design is valid for a reduced claim/burn MVP, but insufficient for a claim that DTN access-rights semantics are enforced or fully represented on-chain. Data product access, API tier, ADC participation, compliance profile, and buyer qualification remain chain-external.

This creates two risks:

- Product/security risk: downstream consumers may assume Solana enforces credential rights that actually live in HK.
- Audit risk: a white-paper audit and a devnet MVP audit will reach different conclusions unless scope is frozen.

Recommendation:

Choose one path:

- Minimal-chain path: keep Solana minimal, but explicitly state that HK is the sole authority for DTN rights/tier/policy and that Solana only gates claim execution.
- Stronger-chain-anchor path: add a compact `credential_policy_hash` or `registry_snapshot_hash` anchored into DTN issuance or settlement batches so off-chain rights can be audited against a stable commitment.

Do not add full rights tables on-chain unless they directly reduce trust or audit risk; that would likely increase surface area without improving the claim/burn MVP.

### ACTUM-SOL-003: Burn Oracle Attestation Is An Anchor, Not On-Chain Self-Verifying Evidence

Severity: Medium

Type: Oracle / auditability / governance

Evidence:

- `submit_burn_proposal` accepts `verified_online_device_days`, `reference_price_micros`, `oracle_attestation_hash`, and `burn_amount`.
- The on-chain validation only checks that device days, reference price, burn amount are positive and `oracle_attestation_hash` is non-zero.
- The TS helper builds a stable payload and computes `oracle_attestation_hash` off-chain.
- The `BurnProposal` account stores only `proposal_id`, `period`, `oracle_attestation_hash`, and `burn_amount`; it does not persist `verified_online_device_days`, `reference_price_micros`, or `sourceId` as state.

Impact:

The current implementation provides an immutable hash anchor, not a self-verifying oracle proof. A privileged treasury actor cannot steal user claims through this path because burn is reserve-protected, but it can submit any non-zero hash. Later auditors must rely on events and off-chain records to reconstruct whether the hash matched the intended oracle payload.

Recommendation:

Before mainnet:

- Store enough attestation fields on-chain to reconstruct the hash, or store a signed attestation blob/hash with signer domain.
- Require a governance-approved oracle signer, multisig, or attestation authority.
- Keep burn discretionary and separate from claim, but make burn evidence independently auditable from durable state, not only helper convention and events.

For devnet MVP, current behavior is acceptable if documented as a hash-anchor-only burn smoke.

### ACTUM-SOL-004: DTN Owner Self-Custody Is Not Enforced On-Chain At Issuance

Severity: Medium

Type: Account model / availability / compliance boundary

Evidence:

- `IssueDtn.owner_wallet` is an `UncheckedAccount`.
- `validate_dtn_issue_shape` rejects only the default pubkey, empty/oversized ID, and non-forward expiry.
- State-machine test `dtn_issue_accepts_off_curve_owner_wallet` explicitly accepts an off-curve PDA-like owner wallet.
- `claim_leaf` later requires `owner_wallet: Signer`, so an off-curve DTN owner cannot claim directly.
- Program README states on-curve / self-custody validation is delegated to HK/client policy.

Impact:

This is not an external theft vector. It is a dead-credential and compliance risk: if HK/client validation fails, the settlement authority can issue a DTN to a non-signable address that can never execute self-custody claim.

Recommendation:

Preferred:

- Require the owner wallet to sign during `issue_dtn`, or require a user-signed purchase/ownership attestation verified by HK and anchored in the DTN issuance record.

If the program cannot enforce on-curve in SBF:

- Keep it explicitly off-chain, but update evidence docs so they do not claim on-chain rejection.
- Add an HK mandatory test proving off-curve owner wallets are rejected before chain submission.
- Include the HK validation result in issuance evidence artifacts.

### ACTUM-SOL-005: Production Governance And Treasury Readiness Are Not Represented On-Chain

Severity: Medium

Type: Governance / treasury / mainnet readiness

Evidence:

- `GlobalState` has `settlement_authority`, `treasury_authority`, and `guardian_authority`.
- Current reduced surface has no online authority reconfiguration path.
- Burn execution is an explicit treasury-authority action, but the program does not encode board review, legal clearance, oracle quorum, timelock, multisig threshold, or Cayman readiness gates.
- Execution plan states Cayman is currently only a minimal read-only treasury baseline and L5 issuance/governance automation is out of scope.

Impact:

This is acceptable for devnet and controlled MVP. It is not sufficient as a production treasury/governance model if public materials imply governance-conditioned burns, SLP/MM controls, reserve policy, or liquidity oversight are already enforced by protocol logic.

Recommendation:

- Keep current Solana burn surface narrow for MVP.
- Before mainnet, define authority custody, multisig, timelock, legal gate, oracle gate, emergency pause, and operational runbooks.
- Decide which controls must be on-chain and which must remain operational/legal evidence.

### ACTUM-SOL-006: Global Claim Reserve Creates A Hot-Account Throughput Bottleneck

Severity: Low / Medium

Type: Performance / scalability

Evidence:

- `claim_leaf` mutates `global_state.reserved_claim_amount` for every claim.
- `submit_batch`, `supersede_batch`, `claim_leaf`, and `execute_burn_proposal` all rely on the shared claim vault reserve invariant.
- Tests prove burn cannot consume balance reserved for claims.

Impact:

The global reserve design is clean for safety, but all claims contend on one writable global account. This serializes the high-volume claim lane and may become a bottleneck under large public claim events.

Recommendation:

- Keep for devnet MVP because the invariant is simple and safe.
- Before scale testing, model expected concurrent claims and benchmark Solana account contention.
- If needed, shard reserve accounting by period or batch while preserving burn protection.

## 7. Risk Matrix

| Area | Current State | Risk |
|---|---|---|
| Claim execution | Strong for MVP | Low |
| Claim reserve vs burn | Strong for MVP | Low |
| DTN minimal credential | Intentional but incomplete | High if marketed as full white-paper credential |
| Burn oracle proof | Hash anchor only | Medium |
| Governance/treasury | Operational baseline only | Medium |
| Docs/evidence truth | Conflicting | High |
| Full white-paper implementation | Not complete | High |
| Marketplace/custody prohibition | No violating Solana path observed | Low |

## 8. Recommended Release Decision

Do not stop the devnet MVP because of white-paper scope gaps. The MVP is deliberately narrower and has passing claim/burn evidence.

Do stop any messaging that says the current Solana program implements the full ACTUM v3.6 white paper.

Recommended next gates:

1. Fix the active truth split: reconcile manifest, program README, evidence matrix, and acceptance contract.
2. Freeze a public audit scope statement: "claim/burn devnet MVP only."
3. Decide DTN policy path: minimal-chain with HK authority, or add compact policy/registry hash anchors.
4. Harden burn attestation for auditability before mainnet.
5. Define production governance/treasury controls before any mainnet or public value-bearing release.

## 9. Final Auditor Statement

The current ACTUM v3 Solana program is best understood as:

> a reduced L4 claimable-truth and discretionary-burn program, integrated with HK evidence flow for devnet MVP.

It is not:

> a complete on-chain implementation of POHA, DTN access rights, data products, ADC, FACT economics, treasury/liquidity governance, or the full ACTUM white-paper stack.

The highest-value fix is not another local code patch. The highest-value fix is to make the active truth unambiguous, then harden only the protocol surfaces that remain inside the frozen release scope.
