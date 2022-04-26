set.seed(123456)

id <- 1:500

disease <- sample(c("Yes", "No"), size = 500, replace = TRUE)

exposure1 <- sample(c(0, 1), size = 500, replace = TRUE)

exposure2 <- sample(c("Yes", "No"), size = 500, replace = TRUE)

exposure3 <- sample(c("shop worker", "education worker", "office worker", "child"), size = 500, replace = TRUE)

disease_expose_data <- data.frame(id = id,
                                    disease = disease,
                                    exposure1 = exposure1,
                                    exposure2 = exposure2,
                                    exposure3 = exposure3
)

usethis::use_data(disease_expose_data, compress = "xz")
