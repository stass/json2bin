# JSON to BSON/CBOR Converter

This is a simple Ruby command-line tool to convert a JSON file into either BSON or CBOR format.

## Features

- Converts JSON to either **BSON** or **CBOR**

## Requirements

- Ruby
- Gems:
  - `json`
  - `bson`
  - `cbor`
  - `optparse` (part of Ruby stdlib)

You can install the required gems using:

```csh
% gem install json bson cbor
````

## Usage

```csh
% ./json2bin.rb -f {bson,cbor} input.json output_file
```

### Arguments

* `-f FORMAT` or `--format FORMAT`: Desired output format. Must be either `bson` or `cbor`. Defaults to `bson`.
* `input.json`: Path to the input JSON file.
* `output_file`: Path to the output file where encoded data will be saved.

### Example

Convert a JSON file to BSON:

```csh
% ./json2bin.rb -f bson data.json data.bson
```

Convert a JSON file to CBOR:

```csh
%  ./json2bin.rb -f cbor data.json data.cbor
```

## License

BSD
