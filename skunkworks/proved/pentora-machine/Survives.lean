import Degraded

namespace Pentora

/-- With x offline, y is a distinct online organ, the three others report g truthfully, and all four online reports pass in every cell. -/
structure Premises (g : Body) (R : Fin 5 → Report) (x y : Fin 5) : Prop where
  distinct : y ≠ x
  honest : ∀ c, c ≠ x → c ≠ y → R c = view g c
  passed : ∀ c, c ≠ x → ∀ t ∈ cellsOf (R c), t = .pass

/-- If x is offline, every online report passes in every cell, and the three organs other than x and y report their true views of g, then x and y share every nonpassing corner and at least 18 of the 20 corners pass. -/
theorem at_least_18 (g : Body) (R : Fin 5 → Report) (x y : Fin 5) (h : Premises g R x y) :
    (∀ v, g.corn v ≠ .pass → SharedBy v x y) ∧
    18 ≤ (fins 20).countP (fun v => decide (g.corn v = .pass)) := by
  have accepted : go4 R x = true := by
    refine (go4_iff R x).2 ⟨?_, h.passed⟩
    intro v h₁ h₂
    have first := ((report_pass_iff _).1 (h.passed _ h₁)).2 (home1 v).2
    have second := ((report_pass_iff _).1 (h.passed _ h₂)).2 (home2 v).2
    exact first.trans second.symm
  have passes (v : Fin 20) (outside : ¬ SharedBy v x y) : g.corn v = .pass := by
    apply Decidable.byContradiction
    intro bad
    have rejected := one_part_cannot_force_go4 g R x y h.distinct h.honest v bad outside
    simp [accepted] at rejected
  refine ⟨fun v bad => Decidable.byContradiction (fun outside => bad (passes v outside)), ?_⟩
  have count : ∀ a b : Fin 5, b ≠ a →
      (fins 20).countP (fun v => decide (¬ SharedBy v a b)) = 18 := by decide +kernel
  rw [← count x y h.distinct]
  exact List.countP_mono_left fun v _ outside => decide_eq_true (passes v (of_decide_eq_true outside))

/-- If x is offline, every online report passes in every cell, and the three organs other than x and y report their true views of g, then every corner whose two owners are online passes in g. -/
theorem named_corners (g : Body) (R : Fin 5 → Report) (x y : Fin 5) (h : Premises g R x y)
    (v : Fin 20) (first : (home1 v).1 ≠ x) (second : (home2 v).1 ≠ x) : g.corn v = .pass := by
  apply Decidable.byContradiction
  intro bad
  rcases (at_least_18 g R x y h).1 v bad with ⟨hx, _⟩ | ⟨_, hx⟩
  · exact first hx
  · exact second hx

/-- For every offline organ x, exactly 12 of the 20 corners have both owners different from x. -/
theorem named_corners_count : ∀ x : Fin 5,
    (fins 20).countP (fun v => decide ((home1 v).1 ≠ x ∧ (home2 v).1 ≠ x)) = 12 := by
  decide +kernel

private def passingReport : Report := ⟨fun _ => .pass, fun _ => .pass⟩

/-- There exist a body g, an offline x, a distinct online y, and four all-pass online reports truthful outside x and y such that both corners shared by x and y are nonpassing in g and exactly 18 corners pass. -/
theorem two_can_fail : ∃ (g : Body) (x y : Fin 5) (R : Fin 5 → Report), Premises g R x y ∧
    (∀ v, SharedBy v x y → g.corn v ≠ .pass) ∧
    (fins 20).countP (fun v => decide (g.corn v = .pass)) = 18 := by
  let g : Body := ⟨fun _ _ => .pass, fun v => if SharedBy v 0 1 then .fail else .pass⟩
  refine ⟨g, 0, 1, fun _ => passingReport, ⟨by decide, ?_, ?_⟩, ?_, by decide +kernel⟩
  · have outside : ∀ c : Fin 5, c ≠ 0 → c ≠ 1 → ∀ j : Fin 8, ¬ SharedBy (slot c j) 0 1 := by
      decide +kernel
    intro c cx cy
    apply Report.ext'
    · rfl
    · funext j
      simp [passingReport, view, g, outside c cx cy j]
  · exact fun _ _ => (report_pass_iff _).2 ⟨fun _ => rfl, fun _ => rfl⟩
  · intro v shared
    simp [g, shared]

/-- For every offline x and private cell (c, i), there exist a body g in which that cell is nonpassing, a distinct online y equal to c whenever c is online, and four all-pass online reports truthful about g outside x and y. -/
theorem no_private_named (x c : Fin 5) (i : Fin 18) : ∃ (g : Body) (y : Fin 5) (R : Fin 5 → Report),
    Premises g R x y ∧ (c ≠ x → y = c) ∧ g.priv c i ≠ .pass := by
  let y := if c = x then x + 1 else c
  have other : ∀ a : Fin 5, a + 1 ≠ a := by decide +kernel
  have distinct : y ≠ x := by by_cases eq : c = x <;> simp [y, eq, other]
  have online (cx : c ≠ x) : y = c := if_neg cx
  let g : Body := ⟨fun d j => if d = c ∧ j = i then .fail else .pass, fun _ => .pass⟩
  refine ⟨g, y, fun _ => passingReport, ⟨distinct, ?_, ?_⟩, online, by simp [g]⟩
  · intro d dx dy
    have dc : d ≠ c := by
      intro eq
      subst d
      exact dy (online dx).symm
    apply Report.ext'
    · funext j
      simp [passingReport, view, g, dc]
    · rfl
  · exact fun _ _ => (report_pass_iff _).2 ⟨fun _ => rfl, fun _ => rfl⟩

/-- The 90 private slots, in organ order and then in local slot order. -/
def privateSlots : List (Fin 5 × Fin 18) :=
  (fins 5).flatMap fun c => (fins 18).map fun i => (c, i)

/-- If x is offline, every online report passes in every cell, and the three organs other than x and y report their true views of g, then every private cell outside x and y passes in g and at least 54 of its 90 private cells pass. -/
theorem at_least_54 (g : Body) (R : Fin 5 → Report) (x y : Fin 5) (h : Premises g R x y) :
    (∀ c, c ≠ x → c ≠ y → ∀ i, g.priv c i = .pass) ∧
    54 ≤ privateSlots.countP (fun p => decide (g.priv p.1 p.2 = .pass)) := by
  have passes (c : Fin 5) (cx : c ≠ x) (cy : c ≠ y) : ∀ i, g.priv c i = .pass := by
    have reported := (report_pass_iff _).1 (h.passed c cx)
    rw [h.honest c cx cy] at reported
    exact reported.1
  refine ⟨passes, ?_⟩
  have count : ∀ a b : Fin 5, b ≠ a →
      privateSlots.countP (fun p => decide (p.1 ≠ a ∧ p.1 ≠ b)) = 54 := by decide +kernel
  rw [← count x y h.distinct]
  apply List.countP_mono_left
  intro p _ outside
  obtain ⟨cx, cy⟩ := of_decide_eq_true outside
  exact decide_eq_true (passes p.1 cx cy p.2)

end Pentora
