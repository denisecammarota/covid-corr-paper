f <- function(T, tau, N0, a, f0)
#fitting expression: already have, it´s the int_seir_mp.R
{
  expr <- expression(N0 * exp(-T/tau) * (1 + a*cos(f0*T)))
  eval(expr)
}

T <- seq(0, 8, length=501)

p <- c(tau = 2.2, N0 = 1000, a = 0.25, f0 = 8)

Ndet <- do.call("f", c(list(T = T), as.list(p)))

set.seed(17)
N <- Ndet +  rnorm(length(Ndet), mean=Ndet, sd=.01*max(Ndet))
head(N)


# residuals function
fcn <- function(p, T, N, fcall)
  (N - do.call("fcall", c(list(T = T), as.list(p))))



guess <- c(tau = 2.2, N0 = 1500, a = 0.25, f0 = 10) # initial guess

# doing the fitting
out <- nls.lm(par = guess, fn = fcn,
              fcall = f,
              T = T, N = N, control = nls.lm.control(nprint=1))

