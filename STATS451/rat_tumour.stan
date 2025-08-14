//data {
  //int<lower=0> J; // number of labs 
  //int<lower = 0> y[J]; // number of rats that developed tumour in each lab
  //int<lower = 0> N[J]; // total number of rats in each lab 
//}
//parameters {
  //real<lower=0,upper=1> gamma; 
  //real<lower=0,upper=1> eta;
  //real<lower=0,upper=1> theta[J];
//}
//transformed parameters{
  //real<lower = 0> alpha = gamma/eta^2;
  //real<lower = 0> beta = (1/gamma - 1)*(gamma/eta^2);
//}
//model {
  //gamma ~ uniform(0,1);
  //eta ~ uniform(0,1);
  
  //for (j in 1:J){
    //theta[j] ~ beta(alpha + y[j], beta + N[j] - y[j]);
    //y[j] ~ binomial(N[j], theta[j]);
  //}
//}


// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> J;          // Number of trials
  int<lower=0> y[J];       // Successes for each trial
  int<lower=0> n[J];       // Total attempts for each trial
}

parameters {
  real<lower=0, upper=1> theta[J]; // Probabilities of success for each trial
  real<lower=0, upper=1> gamma;    // Uniform parameter
  real<lower=0, upper=1> eta;      // Uniform parameter
}

transformed parameters {
  real<lower=0> alpha = gamma / eta^2;       // Derived parameter alpha
  real<lower=0> beta = (1 / gamma - 1) * alpha; // Derived parameter beta
}

model {
  gamma ~ uniform(0, 1); // Prior for gamma
  eta ~ uniform(0, 1);   // Prior for eta

  for (j in 1:J) {
    theta[j] ~ beta(alpha, beta); // Beta likelihood
    y[j] ~ binomial(n[j], theta[j]); // Binomial likelihood
  }
}
