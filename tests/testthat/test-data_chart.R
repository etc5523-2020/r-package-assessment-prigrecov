test_that("Input column", {
  res <- data_chart(covidData, group_byparameter="location")
  expect_error(data_chart(dataset = NULL))
  expect_error(data_chart(group_byparameter = NULL))
  expect_error(data_chart(dataset = ""))
  expect_error(data_chart(group_byparameter = ""))
  expect_error(data_chart(covidData, ""))
  expect_error(data_chart("", "location"))
  expect_error(data_chart("", ""))
  expect_error(data_chart(character(0L)))
  expect_error(data_chart(group_byparameter %nin% c("location","continent")))
})

test_that("Output DF", {
  res <- data_chart(covidData,group_byparameter="location")
  expect_true(class(res)[3] == "data.frame")
})