/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#ifdef XLA_OPS_BASE
#else
#define XLA_OPS_BASE

#ifdef OP_BASE
#else
include "mlir/IR/OpBase.td"
#endif // OP_BASE

def XLA_Int : IntOfWidths<[8, 16, 32, 64]>;
def XLA_Pred : TypeAlias<I1, "pred (AKA boolean or 1-bit integer)">;

//===----------------------------------------------------------------------===//
// XLA nullary op definitions.
//===----------------------------------------------------------------------===//

class BXLA_ConstOp {
  string summary = "Constant operator";

  string description = [{
    Represents a constant value.
  }];
}

class BXLA_IotaOp {
  string summary = "Iota operator";

  string description = [{
    Creates a rank 1 array of values starting at zero and incrementing by one.
  }];
}

//===----------------------------------------------------------------------===//
// XLA unary elementwise op definitions.
//===----------------------------------------------------------------------===//
// See https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions

class BXLA_AbsOp {
  string summary = "Absolute value operator";

  string description = [{
    Returns `abs(operand)` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions.
  }];
}

class BXLA_ConvertOp {
  string summary = "Convert operator";

  string description = [{
    Performs element-wise conversion of values from one type to another, e.g.
    float to int.

    See https://www.tensorflow.org/xla/operation_semantics#convertelementtype.
  }];
}

class BXLA_ExpOp {
  string summary = "Exponential operator";

  string description = [{
    Returns `e^(operand)` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions.
  }];
}

class BXLA_NegOp {
  string summary = "Negation operator";

  string description = [{
    Returns `-operand` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions.
  }];
}

class BXLA_SignOp {
  string summary = "Sign operator";

  string description = [{
    Returns `sign(operand)` element-wise, where

    ```
    sign(x) = -1  : x < 0
            = -0  : x = -0
            = NaN : x = NaN
            = +0  : x = +0
            = 1   : x > 0
    ```

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions.
  }];
}

class BXLA_TanhOp {
  string summary = "Tanh operator";

  string description = [{
    Returns `tanh(operand)` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_unary_functions.
  }];
}

//===----------------------------------------------------------------------===//
// XLA binary elementwise op definitions.
//===----------------------------------------------------------------------===//

// The broadcasting dimensions correspond to a tuple that describes how a
// smaller rank shape is broadcast into a larger rank shape. For example,
// given a 2x3x4 cuboid and a 3x4 matrix, a broadcasting tuple (1,2) means
// matching the matrix to dimensions 1 and 2 of the cuboid.
def BroadcastDimAttr : OptionalAttr<ElementsAttr>;

class BXLA_AddOp {
  string summary = "Addition operator";

  string description = [{
    Returns `lhs + rhs` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_DivOp {
  string summary = "Division operator";

  string description = [{
    Returns `lhs / rhs` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_MaxOp {
  string summary = "Maximum operator";

  string description = [{
    Returns `max(lhs, rhs)` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_MinOp {
  string summary = "Minimum operator";

  string description = [{
    Returns `min(lhs, rhs)` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_MulOp {
  string summary = "Multiplication operator";

  string description = [{
    Returns `lhs * rhs` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_SubOp {
  string summary = "Subtraction operator";

  string description = [{
    Returns `lhs - rhs` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

class BXLA_AndOp {
  string summary = "Logical and";

  string description = [{
    Returns `lhs /\ rhs` element-wise.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_binary_arithmetic_operations.
  }];
}

//===----------------------------------------------------------------------===//
// XLA control flow op definitions.
//===----------------------------------------------------------------------===//

class BXLA_ReduceOp {
  string summary = "Reduce operator";

  string description = [{
    Returns the result of executing a reduction function on one or more arrays
    in parallel.

    See https://www.tensorflow.org/xla/operation_semantics#reduce.
  }];
}

//===----------------------------------------------------------------------===//
// XLA tuple op definitions.
//===----------------------------------------------------------------------===//
class BXLA_GetTupleElementOp {
  string summary = "GetTupleElement operator";

  string description = [{
    Returns a member of a tuple specified by an index.

    See https://www.tensorflow.org/xla/operation_semantics#gettupleelement.
  }];
}

class BXLA_TupleOp {
   string summary = "XLA's tuple op";

   string description = [{
     Groups a set of tensor inputs into a single tuple object.

     See https://www.tensorflow.org/xla/operation_semantics#tuple.
   }];
}

//===----------------------------------------------------------------------===//
// Precision Config enum definitions.
//===----------------------------------------------------------------------===//

// These mirror the XLA PrecisionConfig proto enum.
def XLA_PRECISION_DEFAULT : StrEnumAttrCase<"DEFAULT">;
def XLA_PRECISION_HIGH    : StrEnumAttrCase<"HIGH">;
def XLA_PRECISION_HIGHEST : StrEnumAttrCase<"HIGHEST">;

def XLA_PrecisionAttr : StrEnumAttr<"Precision",
    "XLA precision for an operand. Has backend specific meaning.",
    [XLA_PRECISION_DEFAULT,  XLA_PRECISION_HIGH, XLA_PRECISION_HIGHEST]>;

// TODO(b/129153247) See if it's possible to also validate the size.
def XLA_PrecisionConfigAttr:
    OptionalAttr<
          TypedArrayAttrBase<XLA_PrecisionAttr, "Precision Config attribute">>;

//===----------------------------------------------------------------------===//
// Comparison op definitions.
//===----------------------------------------------------------------------===//

// These mirror the XLA ComparisonDirection enum.
def XLA_COMPARISON_DIRECTION_EQ : StrEnumAttrCase<"EQ">;
def XLA_COMPARISON_DIRECTION_NE : StrEnumAttrCase<"NE">;
def XLA_COMPARISON_DIRECTION_GE : StrEnumAttrCase<"GE">;
def XLA_COMPARISON_DIRECTION_GT : StrEnumAttrCase<"GT">;
def XLA_COMPARISON_DIRECTION_LE : StrEnumAttrCase<"LE">;
def XLA_COMPARISON_DIRECTION_LT : StrEnumAttrCase<"LT">;

def XLA_ComparisonDirectionAttr : StrEnumAttr<"ComparisonDirection",
    "Which comparison operation to perform.",
    [
      XLA_COMPARISON_DIRECTION_EQ,
      XLA_COMPARISON_DIRECTION_NE,
      XLA_COMPARISON_DIRECTION_GE,
      XLA_COMPARISON_DIRECTION_GT,
      XLA_COMPARISON_DIRECTION_LE,
      XLA_COMPARISON_DIRECTION_LT
    ]>;

class BXLA_CompareOp {
  string summary = "Comparison operator";

  string description = [{
    Compares `lhs` and `rhs` elementwise according to `comparison_direction`.

    See
    https://www.tensorflow.org/xla/operation_semantics#element-wise_comparison_operations.
  }];
}

//===----------------------------------------------------------------------===//
// XLA Slice definitions.
//===----------------------------------------------------------------------===//

class BXLA_SliceOp {
  string summary = "Slice operator";

  string description = [{
    Slices a portion of the `operand` into a new configuration.

    See https://www.tensorflow.org/xla/operation_semantics#slice.
  }];
}

class BXLA_DynamicUpdateSliceOp {
  string summary = "Dynamic Update Slice operator";

  string description = [{
    DynamicUpdateSlice generates a result which is the value of the input array
    operand, with a slice update overwritten at start_indices.

    See https://www.tensorflow.org/xla/operation_semantics#dynamicupdateslice.
  }];
}

//===----------------------------------------------------------------------===//
// XLA Other op definitions.
//===----------------------------------------------------------------------===//

class BXLA_BatchNormInferenceOp {
  string summary = "Batch Normalization for Inference";

  string description = [{
    Normalizes an array across batch and spatial dimensions.

    See https://www.tensorflow.org/xla/operation_semantics#batchnorminference
  }];
}

class BXLA_BroadcastOp  {
  string summary = "Broadcast a tensor to a higher rank by prepending dimensions";

  string description = [{
    Broadcasts the operand tensor to a higher rank by prepending
    `broadcast_sizes` to the dimensions. The current values of the operand are
    copied into the other dimensions.

    This is a more limited form of broadcasting, that corresponds to the XLA
    client Broadcast method. For a more general form of broadcasting, see the
    BroadcastInDimOp.

    See https://www.tensorflow.org/xla/operation_semantics#broadcast.
  }];
}

class BXLA_BroadcastInDimOp  {
  string summary = "Broadcast a tensor into the given shape by adding dimensions.";

  string description = [{
    Broadcasts the `operand` tensor to a higher rank. This is not the limited
    form of broadcasting exposed as the XLA client broadcast op, but rather the
    more powerful "InDim" broadcasting, which is closer to the HLO broadcast op
    and exposed in the XLA client BroadcastInDim method.

    `broadcast_dimensions` maps the operand dimension number to the target shape
    dimension number. It must have the same size as the rank of the operand. The
    mapped dimensions must either be the same size or the dimension being
    broadcast from must be size 1 (degenerate broadcasting).

    For a scalar (0D tensor) operand, `broadcast_dimensions` must be empty. The
    The scalar value will be broadcast to every element in the target shape.

    See https://www.tensorflow.org/xla/broadcasting.
  }];
}

class BXLA_ClampOp  {
  string summary = "Clamp operator";

  string description = [{
    Clamps an operand to within the range between a minimum and maximum value.

    Note: All three arrays must be the same shape. Alternatively, as a
          restricted form of broadcasting, min and/or max can be a scalar (0D
          tensor) of the element type of the tensor operand.

    See https://www.tensorflow.org/xla/operation_semantics#clamp.
  }];
}

class BXLA_ConcatenateOp {
   string summary = "XLA's concantenate op";

   string description = [{
     Concatenates a set of tensors along the specified dimension.

     See https://www.tensorflow.org/xla/operation_semantics#concatenate.
   }];
}

class BXLA_ConvOp {
  string summary = "Convolution operator";

  string description = [{
    Computes a convolution of the kind used in neural networks.

    See https://www.tensorflow.org/xla/operation_semantics#conv_convolution.
  }];
}

class BXLA_DotOp {
  string summary = "Dot operator";
  string description = [{
    Performs dot products between vectors, vector/matrix and matrix/matrix
    multiplication.

    See https://www.tensorflow.org/xla/operation_semantics#dot.
  }];
}

class BXLA_GatherOp{
  string summary = "Gather operator";

  string description = [{
    Stitches together several slices of an input array.

    See https://www.tensorflow.org/xla/operation_semantics#gather.
  }];
}

class BXLA_ReshapeOp {
  string summary = "Reshape operator";

  string description = [{
    Reshapes the dimensions of `operand` into a new configuration.

    See https://www.tensorflow.org/xla/operation_semantics#reshape.
  }];
}

class BXLA_SelectOp {
  string summary = "Select operator";

  string description = [{
    Constructs an output tensor from the elements of `on_true` and `on_false`
    based on the values of `pred`.

    `on_true` and `on_false` must be the same shape. For each element of `pred`,
    `res` has the corresponding element of `on_true` or `on_false` depending on
    the value in `pred`. `pred` must be the same shape as `on_true` and
    `on_false` or a scalar, in which case `res` is equal to either `on_true` or
    `on_false`.

    See https://www.tensorflow.org/xla/operation_semantics#select.
  }];
}

class BXLA_ReverseOp {
  string summary = "Reverse operator";

  string description = [{
    Reverses the specified dimensions of `operand` according to the given
    `dimensions`.

    See https://www.tensorflow.org/xla/operation_semantics#rev_reverse.
  }];
}

class BXLA_PadOp {
  string summary = "Pad operator";

  string description = [{
    Pads the edges of `operand` with the `padding_value` and according to
    the passed configuration.

    See https://www.tensorflow.org/xla/operation_semantics#pad.
  }];
}

class BXLA_TransposeOp {
  string summary = "Transpose operator";

  string description = [{
    Permutes the dimensions of `operand` according to the given `permutation`.

    `res_dimensions[i] = operand_dimensions[permutation[i]]`

    See https://www.tensorflow.org/xla/operation_semantics#transpose.
  }];
}

#endif // XLA_OPS_BASE
