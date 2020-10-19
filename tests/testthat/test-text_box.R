test_that("Input id text", {
  expect_error(text_box(text = NULL))
  expect_error(text_box(text = ""))
  expect_error(text_box(character(0L)))
  expect_error(text_box(text %nin% c("text0","text4")))
})
