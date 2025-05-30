# Design Document: ElixirScope.Utils (elixir_scope_utils)

## 1. Purpose & Vision

**Summary:** Core, low-level, and foundational utility functions used across multiple ElixirScope components. This library has no ElixirScope-specific dependencies and provides common, reusable helpers.

**(Greatly Expanded Purpose based on your existing knowledge of ElixirScope and CPG features):**

The `elixir_scope_utils` library serves as the bedrock of shared functionality within the ElixirScope ecosystem. Its primary goal is to provide a collection of pure, well-tested, and highly performant utility functions that address common needs encountered by other ElixirScope libraries. This includes tasks such as precise timestamp generation, unique identifier creation, safe data inspection and truncation for logging or storage, performance measurement primitives, and various formatting and validation helpers.

By centralizing these utilities, `elixir_scope_utils` aims to:
*   **Reduce Code Duplication:** Avoid reimplementing common helper functions across multiple libraries.
*   **Ensure Consistency:** Provide a standard way to perform common operations (e.g., timestamping, ID generation).
*   **Improve Reliability:** Offer well-tested and robust implementations for critical low-level tasks.
*   **Enhance Performance:** Focus on efficient implementations for frequently used utilities.
*   **Simplify Development:** Allow other libraries to focus on their core responsibilities by relying on these established utilities.

This library does not directly interact with CPGs or complex analysis features but provides the building blocks that those more advanced libraries will use (e.g., timestamping events that will later be correlated with CPG nodes, generating unique IDs for AST nodes or CPG elements).

This library will enable developers of other ElixirScope components to:
*   Reliably generate monotonic and wall-clock timestamps for event ordering and correlation.
*   Create unique identifiers for various entities within the ElixirScope system.
*   Safely inspect and truncate complex data structures for logging or display without risking crashes or excessive output.
*   Measure the execution time and memory usage of code blocks for performance analysis.
*   Format byte sizes and durations into human-readable strings.
*   Perform basic data validation checks.

## 2. Key Responsibilities

This library is responsible for:

*   Providing high-resolution monotonic and wall-clock timestamp generation.
*   Offering robust and unique identifier generation mechanisms.
*   Supplying functions for safe data inspection and truncation, preventing excessive output or serialization issues.
*   Including helpers for basic performance measurement (e.g., timing function execution).
*   Providing utility functions for formatting data (e.g., byte sizes, durations) into human-readable strings.
*   Offering common validation predicates (e.g., for positive integers, percentages, PIDs).
*   Ensuring all utility functions are pure (where applicable) and well-documented.

## 3. Key Modules & Structure

The primary modules within this library will be:

*   `ElixirScope.Utils`

### Proposed File Tree:

```
elixir_scope_utils/
├── lib/
│   └── elixir_scope/
│       └── utils.ex
├── mix.exs
├── README.md
├── DESIGN.MD
└── test/
    ├── test_helper.exs
    └── elixir_scope/
        └── utils_test.exs
```

**(Greatly Expanded - Module Description):**
*   **`ElixirScope.Utils`**: This module will house all the public utility functions. It will be organized into logical sections (e.g., Timestamp Generation, ID Generation, Data Inspection, Performance Helpers, Formatting, Validation) using comments or potentially private helper functions if the module grows very large. Each public function will be meticulously documented with `@doc` and `@spec`.

## 4. Public API (Conceptual)

The main public interface of this library will be the functions within the `ElixirScope.Utils` module:

*   `ElixirScope.Utils.monotonic_timestamp() :: integer()`
    *   Returns a high-resolution monotonic timestamp in nanoseconds.
*   `ElixirScope.Utils.wall_timestamp() :: integer()`
    *   Returns a wall clock timestamp in nanoseconds.
*   `ElixirScope.Utils.format_timestamp(timestamp_ns :: integer()) :: String.t()`
    *   Formats a nanosecond timestamp into a human-readable ISO8601 string.
*   `ElixirScope.Utils.measure(fun :: (() -> any())) :: {result :: any(), duration_ns :: integer()}`
    *   Executes the given 0-arity function and returns its result along with the execution duration in nanoseconds.
*   `ElixirScope.Utils.generate_id() :: String.t()` (Decided to use String UUIDs for broader compatibility)
    *   Generates a globally unique identifier (e.g., UUID v4).
*   `ElixirScope.Utils.generate_correlation_id() :: String.t()`
    *   Generates a unique correlation ID, potentially using the same mechanism as `generate_id()` or a specific format if needed.
*   `ElixirScope.Utils.safe_inspect(term :: any(), opts :: keyword()) :: String.t()`
    *   Safely inspects a term with limits (e.g., depth, length) to prevent excessive output. Options could include `:limit`, `:printable_limit`.
*   `ElixirScope.Utils.truncate_if_large(term :: any(), max_size_bytes :: non_neg_integer()) :: any() | {:truncated, original_size_bytes :: non_neg_integer(), type_hint :: String.t()}`
    *   Truncates a term if its binary representation exceeds `max_size_bytes`, returning a placeholder.
*   `ElixirScope.Utils.truncate_data(term :: any(), max_size_bytes :: non_neg_integer()) :: any() | {:truncated, original_size_bytes :: non_neg_integer(), type_hint :: String.t()}`
    *   Alias or specialized version of `truncate_if_large` for event data, potentially with a smaller default `max_size_bytes`.
*   `ElixirScope.Utils.term_size(term :: any()) :: non_neg_integer()`
    *   Estimates the memory footprint of a term in bytes using `:erts_debug.flat_size/1`.
*   `ElixirScope.Utils.format_bytes(bytes :: non_neg_integer()) :: String.t()`
    *   Formats a byte size into a human-readable string (e.g., KB, MB, GB).
*   `ElixirScope.Utils.format_duration_ns(nanoseconds :: non_neg_integer()) :: String.t()`
    *   Formats a duration in nanoseconds into a human-readable string (e.g., ns, µs, ms, s).
*   `ElixirScope.Utils.valid_positive_integer?(value :: any()) :: boolean()`
    *   Checks if the value is an integer and greater than 0.
*   `ElixirScope.Utils.valid_percentage?(value :: any()) :: boolean()`
    *   Checks if the value is a number between 0.0 and 1.0 (inclusive).
*   `ElixirScope.Utils.valid_pid?(pid :: any()) :: boolean()`
    *   Checks if the value is a PID and if the process is alive.

## 5. Core Data Structures

This library will primarily define/utilize:

*   No custom public structs. It operates on basic Elixir types and returns basic types or simple tuples.

## 6. Dependencies

This library will depend on the following ElixirScope libraries:

*   None

It will only depend on Elixir core libraries (e.g., `:crypto`, `System`, `DateTime`, `String`, `Enum`, `Map`, `File` for system memory checks if included here).

## 7. Role in TidewaveScope & Interactions

Within the `TidewaveScope` ecosystem, the `elixir_scope_utils` library will:

*   Be a fundamental dependency for nearly all other `elixir_scope_*` libraries.
*   Provide consistent timestamping for all events captured by `elixir_scope_capture_core`.
*   Generate unique IDs for events, correlation contexts, AST nodes (if IDs are generated outside the AST repo), and other entities.
*   Be used by logging and reporting mechanisms within `TidewaveScope` or other ElixirScope libraries for safe data inspection and formatting.
*   Offer performance measurement utilities that can be used by various components to track their own internal performance or the performance of instrumented code.

## 8. Future Considerations & CPG Enhancements

This library is foundational and less likely to be directly impacted by CPG enhancements, but its utilities must remain robust and performant as they underpin more complex operations.

*   **ID Generation Strategies:** If CPG node identification requires specific ID formats or properties (e.g., hierarchical IDs), `generate_id()` might need to become more flexible or specialized versions might be introduced.
*   **Advanced Data Serialization/Truncation:** If CPG analysis produces very large or complex data structures that need to be logged or transmitted, `safe_inspect` and `truncate_if_large` might need more sophisticated strategies for handling graph-like data.
*   **Platform-Specific Utilities:** If ElixirScope needs more detailed platform-specific information (beyond basic OS checks), those utilities might reside here.

## 9. Testing Strategy

*   **Unit Tests:** Each utility function in `ElixirScope.Utils` will have comprehensive unit tests covering:
    *   Correctness of output for various inputs.
    *   Edge cases (e.g., nil inputs, empty lists/strings for truncation).
    *   Performance characteristics for critical functions like `monotonic_timestamp` and `generate_id` (though full benchmarks might be separate).
    *   Validation functions tested with valid and invalid inputs.
    *   Timestamp formatting for different magnitudes.
    *   Byte and duration formatting for various values.
*   **No Integration Tests Needed Within This Library:** As it has no ElixirScope dependencies, its internal correctness is ensured by unit tests. Its integration is tested by the libraries that consume it.
