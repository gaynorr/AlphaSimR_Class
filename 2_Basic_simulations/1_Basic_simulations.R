# Stochastic response to selection simulation ----

# An unreplicated example
g = rnorm(1000)
e = rnorm(1000)
p = g + e
sqrt(0.5)

cor(p, g)

take = order(p, decreasing = TRUE)[1:100]
mean(g[take]) - mean(g)


# A replicated example
response = numeric(1000)

for(i in 1:1000){
  g = rnorm(1000)
  g = g - mean(g)
  
  e = rnorm(1000)
  
  p = g + e
  
  take = order(p, decreasing=TRUE)[1:10]
  
  response[i] = mean(g[take])
}

hist(response)
mean(response)

# Perform two stages of selection
g = rnorm(1000)
g = g - mean(g)

e = rnorm(1000)

p = g + e

take = order(p, decreasing=TRUE)[1:100]

g1 = g[take]
p1 = p[take]

e2 = rnorm(100)
p2 = g1 + e2

p_ave = (p1+p2) / 2

take = order(p_ave, decreasing=TRUE)[1:10]

mean(g1[take])

# Make it replicated
response2 = numeric(1000)

for(i in 1:1000){
  # Simulate genetic effects
  g = rnorm(1000)
  g = g - mean(g)
  
  # Simulate non-additive genetic effects
  e = rnorm(1000)
  
  p = g + e
  
  take = order(p, decreasing=TRUE)[1:100]
  
  g1 = g[take]
  p1 = p[take]
  
  e2 = rnorm(100)
  p2 = g1 + e2
  
  p_ave = (p1+p2) / 2
  
  take = order(p_ave, decreasing=TRUE)[1:10]
  
  response2[i] = mean(g1[take])
}


# Compare response to response2
boxplot(response, response2)

t.test(response, response2)


# Simulating traits with genotypes ----

# Simulate 1000 individuals with 100 additive QTL
M = sample(c(0, 2), 1000*100, replace=TRUE)
M = matrix(M, nrow=1000)

a = rnorm(100)

GV = M %*% a

var(GV)
mean(GV)


# Scale trait to variance 1
a = a / sqrt(var(GV))

var(M %*% a)
GV = M %*% a

mean(GV)

# Set trait mean to 0
GV = GV - mean(GV)
mean(GV)

