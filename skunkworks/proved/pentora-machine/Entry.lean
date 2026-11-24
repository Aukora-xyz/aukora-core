import Pentora
/-! The door between the Wasm file and the laws of `Pentora.lean`. Input: 130 bytes, five reports of 26 cells each
(18 private cells, then 8 corners in the order of `slot`); a cell is 0 (failed), 1 (unknown) or 2 (passed). -/
namespace Pentora

def tritOf (x : UInt8) : Trit := if x = 0 then .fail else if x = 1 then .unknown else .pass
def wellFormed (b : ByteArray) : Bool := b.size == 130 && b.toList.all (· < 3)
def reportOf (b : ByteArray) (c : Fin 5) : Report :=
  ⟨fun k => tritOf (b.get! (c.val * 26 + k.val)), fun j => tritOf (b.get! (c.val * 26 + 18 + j.val))⟩

/-- The five healths as one number in base three, organ 0 lowest. -/
def healths (R : Fin 5 → Report) : Nat := (fins 5).foldr (fun c acc => health (cellsOf (R c)) + 3 * acc) 0

/-- WHAT "NO DISAGREEMENT" MEANS FOR THE BYTES THE FILE WAS GIVEN: one body stands behind the five reports, and
    it is the only one. -/
theorem no_seam_one_body (b : ByteArray) (h : seams (reportOf b) = []) :
    (∀ c, view (glue (reportOf b)) c = reportOf b c) ∧
    ∀ g, (∀ c, view g c = reportOf b c) → g = glue (reportOf b) :=
  ⟨view_glue _ ((seams_nil_iff _).1 h), fun g k => glue_unique _ g k⟩

/-- 0 to 242: the reports agree, and the answer is the five healths in base three. 256 + v: the two owners of
    corner v disagree (the lowest such corner). 0xFFFFFFFF: not 130 bytes of 0, 1, 2. -/
@[export pentora_judge] def judge (b : ByteArray) : UInt32 :=
  if wellFormed b then
    match seams (reportOf b) with
    | v :: _ => (256 + v.val).toUInt32
    | [] => (healths (reportOf b)).toUInt32
  else 0xFFFFFFFF

/-- Bit v is set when the two owners of corner v disagree. -/
@[export pentora_seams] def seamMask (b : ByteArray) : UInt32 :=
  if wellFormed b then ((seams (reportOf b)).foldl (fun (acc : Nat) (v : Fin 20) => acc + 2 ^ v.val) 0).toUInt32 else 0xFFFFFFFF

/-- Bit c is set when organ c owns every disagreeing corner. -/
@[export pentora_suspects] def suspectMask (b : ByteArray) : UInt32 :=
  if wellFormed b then ((suspects (reportOf b)).foldl (fun (acc : Nat) (c : Fin 5) => acc + 2 ^ c.val) 0).toUInt32 else 0xFFFFFFFF

/-- Byte i (0 to 21, lowest first) of the address of the one body behind agreeing reports. -/
@[export pentora_address_byte] def addressByte (b : ByteArray) (i : UInt32) : UInt32 :=
  if wellFormed b && (seams (reportOf b)).isEmpty && decide (i < 22) then
    (addressOf (reportOf b) / 256 ^ i.toNat % 256).toUInt32
  else 0xFFFFFFFF

/-- How many of organ c's 26 cells are t (0 failed, 1 unknown, 2 passed). -/
@[export pentora_tally] def tallyOf (b : ByteArray) (c t : UInt32) : UInt32 :=
  if h : wellFormed b = true ∧ c.toNat < 5 ∧ t.toNat < 3 then
    (tally (Trit.ofCode t.toNat) (cellsOf (reportOf b ⟨c.toNat, h.2.1⟩))).toUInt32
  else 0xFFFFFFFF

/-- The first (w = 0) or second owner of corner v. -/
@[export pentora_owner] def ownerOf (v w : UInt32) : UInt32 :=
  if h : v.toNat < 20 then
    (if w = 0 then (home1 ⟨v.toNat, h⟩).1.val else (home2 ⟨v.toNat, h⟩).1.val).toUInt32
  else 0xFFFFFFFF

/-- The vertex that is corner j of cube c. -/
@[export pentora_vertex] def vertexOf (c j : UInt32) : UInt32 :=
  if h : c.toNat < 5 ∧ j.toNat < 8 then (slot ⟨c.toNat, h.1⟩ ⟨j.toNat, h.2⟩).val.toUInt32 else 0xFFFFFFFF

/-- The seal of the one body behind agreeing reports (0, 1 or 2). -/
@[export pentora_seal] def sealByte (b : ByteArray) : UInt32 :=
  if wellFormed b && (seams (reportOf b)).isEmpty then (sealOf (glue (reportOf b))).toUInt32 else 0xFFFFFFFF

/-- The centre of the one body behind agreeing reports: 0 all passed, 1 something unknown, 2 something failed. -/
@[export pentora_centre] def centreByte (b : ByteArray) : UInt32 :=
  if wellFormed b && (seams (reportOf b)).isEmpty then (centre (glue (reportOf b))).toUInt32 else 0xFFFFFFFF

/-- Corner v with organ x overruled: its value as told by its owner that is not x. -/
@[export pentora_heal] def healByte (b : ByteArray) (x v : UInt32) : UInt32 :=
  if h : wellFormed b = true ∧ x.toNat < 5 ∧ v.toNat < 20 then
    (heal (reportOf b) ⟨x.toNat, h.2.1⟩ ⟨v.toNat, h.2.2⟩).code.toUInt32
  else 0xFFFFFFFF

end Pentora
