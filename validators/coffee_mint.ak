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
                   hash == #"fdd6ea004ba7efee8a464b384b6e43114936cb7b12e244144b790b0c"
                 },
               )
            |> list.foldr(fn(a, b) { value.lovelace_of(a.value) + b }, 0)
        let must_be_signed =
          list.has(
            transaction.extra_signatories,
            #"fe0af408d6cc27c24ce7b38264af5d41efd42ed89bdea5105b0da65b",
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
