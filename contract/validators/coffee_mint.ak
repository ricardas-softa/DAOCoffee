use aiken/interval.{Finite, Interval, IntervalBound, PositiveInfinity}
use aiken/list
use aiken/transaction.{ScriptContext, Transaction, ValidityRange} as tx
use aiken/transaction/credential.{VerificationKeyCredential}
use aiken/transaction/value

type Action {
  Mint
  Burn
}

type POSIXTime =
  Int

validator {
  fn mint_coffee(redeemer: Action, context: ScriptContext) -> Bool {
    let ScriptContext { transaction, .. } =
      context

    let Transaction { mint, .. } =
      transaction

    expect [(_, _, amount)] =
      value.flatten(mint)

    when redeemer is {
      Mint -> {
        let value_paid =
          transaction.outputs
            |> list.filter(
                 fn(output) {
                   expect VerificationKeyCredential(hash) =
                     output.address.payment_credential
                   hash == #"5032b71b5b54ab728a9e8a7ffd9e722e7349fd275d001105c5eedadb"
                 },
               )
            |> list.foldr(fn(a, b) { value.lovelace_of(a.value) + b }, 0)
        let must_be_signed =
          list.has(
            transaction.extra_signatories,
            #"12c15099b30cd9d50f0b917f6b87acc47b62b4c6952ceb7bef91b922",
          )
        must_mint_before_deadline(transaction.validity_range, 1690848000000) && value_paid == 45000000 && must_be_signed && amount == 1
      }
      Burn ->
        amount == -1
    }
  }
}

fn must_mint_before_deadline(range: ValidityRange, deadline: POSIXTime) {
  when range.upper_bound.bound_type is {
    Finite(tx_upper) ->
      tx_upper <= deadline
    _ ->
      False
  }
}

test mint_after_deadline_fails() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
    }

  !must_mint_before_deadline(range, 4)
}

test mint_at_deadline_succeeds() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(4), is_inclusive: True },
    }

  must_mint_before_deadline(range, 4)
}

test mint_before_deadline_succeeds() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(3), is_inclusive: True },
    }

  must_mint_before_deadline(range, 4)
}

test mint_with_infinite_upper_fails() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound {
        bound_type: PositiveInfinity,
        is_inclusive: True,
      },
    }

  !must_mint_before_deadline(range, 4)
}
