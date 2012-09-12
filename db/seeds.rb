pass = Passbook::Pass.create(pass_type_identifier: "com.company.pass.example", serial_number: "ABC123")
pass.data = {
  foo: 57,
  bar: Time.now,
  baz: "Lorem ipsum dolar sit amet"
}
pass.save

pass.registrations.create(device_library_identifier: "123456789", push_token: "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000")
