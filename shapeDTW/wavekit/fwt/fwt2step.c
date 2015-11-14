/*
  Fast wavelet transform (2-dimensional), non-standard form

  [alpha, beta, gamma, news] = fwt2step(s,h,g)

  s     original smooth data
  alpha, beta, gamma, news  
        corresponding new submatrices
  h,g   scaling function and wavelet filter coefficients

  For matlab 5.1

  (C) 1993-1997 Harri Ojanen
*/

#include <math.h>
#include "mex.h"

#define	max(A, B)	((A) > (B) ? (A) : (B))

/*****************************************************************************/

void fwt2step (
	       double s[],
	       double h[],
	       double g[],
	       double alpha[],
	       double beta[],
	       double gamma[],
	       double new_s[],
	       unsigned int N,
	       unsigned int M,
	       unsigned int mask)
{
  unsigned int i, l, k, m;
  unsigned int index, s_index;

  for (i = 0; i < N; i++)
    for (l = 0; l < N; l++) {
      index = l*N+i;
      alpha [index] = 0.0;
      beta [index] = 0.0;
      gamma [index] = 0.0;
      new_s [index] = 0.0;
      for (k = 0; k < M; k++)
	for (m = 0; m < M; m++) {
	  s_index = ((m+2*l) & mask)*N*2 + ((k+2*i) & mask);
	  alpha [index] += g[k]*g[m]*s[s_index];
	  beta  [index] += g[k]*h[m]*s[s_index];
	  gamma [index] += h[k]*g[m]*s[s_index];
	  new_s [index] += h[k]*h[m]*s[s_index];
	}
    }
}


/*****************************************************************************/

/* Input and output arguments */

#define	S_IN prhs[0]
#define	H_IN prhs[1]
#define	G_IN prhs[2]

#define	ALPHA_OUT plhs[0]
#define BETA_OUT plhs[1]
#define GAMMA_OUT plhs[2]
#define S_OUT plhs[3]


/****************************************************************************/

void mexFunction(
		 int nlhs,
		 mxArray *plhs[],
		 int nrhs,
		 const mxArray *prhs[])
{
  double *s, *h, *g;
  double *alpha, *beta, *gamma, *new_s;
  unsigned int N, M, mask;

  /* Check for proper number of arguments */

  if (nrhs != 3) mexErrMsgTxt("fwt2step requires three input arguments.");
  if (nlhs != 4) mexErrMsgTxt("fwt2step requires four output arguments.");
  
  /* Check the dimensions of input parameters */
  
  if (mxGetN(S_IN) != mxGetM(S_IN))
    mexErrMsgTxt ("Input matrix must be square.");
  N = mxGetN(S_IN) / 2;
  mask = mxGetN(S_IN) - 1;

  M = max (mxGetM(H_IN), mxGetN(H_IN));
  if (max (mxGetM(G_IN), mxGetN(G_IN)) != M)
    mexErrMsgTxt ("Input vectors h and g must be of the same length.");
  if ((mxGetM(H_IN) != 1) && (mxGetN(H_IN) != 1) ||
      (mxGetM(G_IN) != 1) && (mxGetN(G_IN) != 1)) 
    mexErrMsgTxt ("Input arguments h and g must be vectors.");

  /* Create matrices for the return arguments */
  
  ALPHA_OUT = mxCreateDoubleMatrix (N, N, mxREAL);
  BETA_OUT = mxCreateDoubleMatrix (N, N, mxREAL);
  GAMMA_OUT = mxCreateDoubleMatrix (N, N, mxREAL);
  S_OUT = mxCreateDoubleMatrix (N, N, mxREAL);
  
  /* Assign pointers to the various parameters */
  
  s = mxGetPr(S_IN);
  h = mxGetPr(H_IN);
  g = mxGetPr(G_IN);
  alpha = mxGetPr(ALPHA_OUT);
  beta = mxGetPr(BETA_OUT);
  gamma = mxGetPr(GAMMA_OUT);
  new_s = mxGetPr(S_OUT);
  
  /* Do the actual computations */
  
  fwt2step (s, h, g, alpha, beta, gamma, new_s, N, M, mask);
}
