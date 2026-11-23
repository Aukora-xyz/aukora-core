# The authority sequel: how the owner's fingerprint becomes Core authority without an agent ever holding a
# signing key. Design note, Mythos, 23 November 2026. Nothing here is built. Keys and where they live are the
# owner's decisions; this note only lays them out.

## The problem as it stands (SOURCE)
An approval is two signatures, Ed25519 and ML-DSA-65, made with raw key files. Whatever holds the files can approve.
Lab signatures today are a rehearsal, not the owner's consent. With the agent autonomous, the agent's side must never
hold those keys, and the owner's act must be one fingerprint for one exact thing.

## Three ways, and what each really gives
1. **Wrapped keys.** The two keys stay, encrypted at rest; a secret released by the passkey unwraps them inside an
   isolated signer for one signature. No Core change. But the keys exist in software at signing time, and the
   isolation of that signer is the entire defence.
2. **The passkey IS the approval key (recommended).** A new owner form whose signature is a passkey assertion. The
   signed challenge is a digest of: a fixed label, the record identifier, the head, the line number and the intent.
   The Core checks the assertion (P-256), the "user verified" flag and the challenge. No exportable signing key
   exists anywhere; one fingerprint signs one exact frame of one exact record. The existing pair of keys becomes the
   COLD ROOT: kept off every machine the agent runs on, used only to enrol or revoke a passkey, to change the root,
   and to recover.
3. **A broker with a mandate.** The passkey signs a short-lived mandate; a broker holding the Core keys signs when
   shown one. The broker then holds the keys, which is the thing to avoid unless it is a hardware module.

## What way 2 needs from the Core (after root v2 steps 3a and 3b)
- One new form, admitted through the form table as the first NEW form (a new form arrives with a new machine).
- P-256 signature checking written in Lean, compiled and tested like the other primitives (tested, not proved).
- Laws: (i) an assertion admitted for record I at head h is refused everywhere else (the binding law extended; true
  by construction because the challenge contains I and h); (ii) "user verified" is required; (iii) a passkey is
  enrolled or revoked only by the cold root; (iv) the no-lockout guard counts the passkey form as an approval form,
  and recovery never depends on it.
- A stated loss: passkey signatures are not post-quantum. The cold root stays hybrid; day-to-day approvals would
  not be. That trade is the owner's to accept or refuse.

## What no law can cover
The authenticator's honesty, the browser's binding of a passkey to an origin, and the screen that tells the owner
what is being approved. The digest signed is exact; that the owner SAW the same thing is a property of the
approval screen, to be tested on the built surface, not proved.

## Decisions that are the owner's alone
Where the cold root lives; which site name the passkey is bound to; whether day-to-day approvals may be
non-post-quantum; how many passkeys and how one is revoked.

## Order
Root v2 step 3a (bound records refuse the two old forms), 3b (restriction frames and the guard), then this form.
Until it exists, every approval made in the lab is a rehearsal and every page says so.
