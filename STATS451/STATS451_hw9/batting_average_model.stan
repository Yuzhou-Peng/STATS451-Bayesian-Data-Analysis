
data {
  int<lower = 1> Nsubj;  //number of subject
  int<lower = 1> Ncat;  //number of categories
  int<lower = 0> N[Nsubj];  //Total trials for each subject
  int<lower = 1> c[Nsubj];  //Category for each subject
  int<lower = 0> y[Nsubj];  //Counts of success for each subject
}
parameters {
  real<lower=0, upper=1> omega[Ncat];      // Omega for each category
  real<lower=2> kappaMinusTwo[Ncat];       // kappa - 2 for each category
  real<lower=2> kappaMinusTwo0;            // kappaO - 2 hyper parameter
  real<lower=0, upper=1> omega0;           // omega0 hyper parameter
  real<lower=0, upper=1> theta[Nsubj];      // success rate for each subject
}
transformed parameters {
  real<lower = 1> alpha0;
  real<lower = 1> beta0;
  real<lower = 1> alpha[Ncat];
  real<lower = 1> beta[Ncat];
  
  alpha0 = omega0 * kappaMinusTwo0 + 1;
  beta0 = (1-omega0) * kappaMinusTwo0 + 1;
  
  for (i in 1:Ncat){
    alpha[i] = omega[i] * kappaMinusTwo[i] + 1;
    beta[i] = (1-omega[i]) * kappaMinusTwo[i] + 1;
  }
}
model {
  omega0 ~ beta(1, 1); // prior for the hyper parameter
  kappaMinusTwo0 ~ gamma(0.01, 0.01); // prior for the hyper parameter
  
  for (j in 1:Ncat){
    omega[j] ~ beta(beta0, alpha0);  
    kappaMinusTwo[j] ~ gamma(0.01, 0.01);
  }
  
  for (i in 1:Nsubj){
    theta[i] ~ beta(alpha[c[i]], beta[c[i]]);
  }
  
  for (k in 1:Nsubj){
    y[k] ~ binomial(N[k], theta[k]);
  }
}

