// RUN: %target-swift-emit-silgen -enable-sil-ownership %s | %FileCheck %s

public struct G<T> {
  var t: T

  public init(t: T) { self.t = t }
}

public func takesAutoclosureAndEscaping(_: @autoclosure () -> (), _: @escaping () -> ()) {}
public func takesVarargs(_: Int...) {}

public func f() {
  _ = G(t: takesAutoclosureAndEscaping)
  _ = G(t: takesVarargs)
}

// We shouldn't have @autoclosure and @escaping attributes in the lowered tuple type:

// CHECK-LABEL: sil shared [transparent] [serializable] [reabstraction_thunk] @$SIg_Ieg_Iegyg_ytytIgnr__ytytIegnr_tytIegnr_TR : $@convention(thin) (@in_guaranteed (@noescape @callee_guaranteed (@in_guaranteed ()) -> @out (), @callee_guaranteed (@in_guaranteed ()) -> @out ()), @guaranteed @callee_guaranteed (@noescape @callee_guaranteed () -> (), @guaranteed @callee_guaranteed () -> ()) -> ()) -> @out ()

// The one-element vararg tuple ([Int]...) should be exploded and not treated as opaque,
// even though its materializable:

// CHECK-LABEL: sil shared [transparent] [serializable] [reabstraction_thunk] @$SSaySiGIegg_AAytIegnr_TR : $@convention(thin) (@in_guaranteed Array<Int>, @guaranteed @callee_guaranteed (@guaranteed Array<Int>) -> ()) -> @out ()
