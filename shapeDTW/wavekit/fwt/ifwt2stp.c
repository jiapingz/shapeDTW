/*
  Inverse fast wavelet transform (2-dimensional), non-standard form

  sout = ifwt2stp(alpha, beta, gamma, s, h, g)

  alpha, beta, gamma, s    submatrices
  sout  new data on one level up
  h,g   scaling function and wavelet filter coefficients

  For matlab 5.1

  (C) 1997 Harri Ojanen
*/

#include <math.h>
#include "mex.h"

#define	max(A, B)	((A) > (B) ? (A) : (B))

/*****************************************************************************/

void ifwt2step (
		double sout[],
		double h[],
		double g[],
		double alpha[],
		double beta[],
		double gamma[],
		double s[],
		unsigned int N,
		unsigned int M,
		unsigned int mask)
{
  unsigned int i, l, k, m;
  unsigned int index00, index01, index10, index11, index;

  for (i = 0; i < N; i++)
    for (l = 0; l < N; l++) {
      index00 = 2*l*2*N + 2*i;
      index10 = 2*l*2*N + 2*i+1;
      index01 = (2*l+1)*2*N + 2*i;
      index11 = (2*l+1)*2*N + 2*i+1;
      sout [index00] = 0.0;
      sout [index01] = 0.0;
      sout [index10] = 0.0;
      sout [index11] = 0.0;
      
      for (k = 0; k < M; k++)
	for (m = 0; m < M; m++) {
	  index = ((l-m) & mask)*N + ((i-k) & mask);
          sout [index00] +=
	    g[2*k]*g[2*m]*alpha[index] + g[2*k]*h[2*m]*beta[index] +
            h[2*k]*g[2*m]*gamma[index] + h[2*k]*h[2*m]*s[index];
          sout [index01] +=
	    g[2*k]*g[2*m+1]*alpha[index] + g[2*k]*h[2*m+1]*beta[index] +
	    h[2*k]*g[2*m+1]*gamma[index] + h[2*k]*h[2*m+1]*s[index];
          sout [index10] +=
	    g[2*k+1]*g[2*m]*alpha[index] + g[2*k+1]*h[2*m]*beta[index] +
	    h[2*k+1]*g[2*m]*gamma[index] + h[2*k+1]*h[2*m]*s[index];
          sout [index11] +=
	    g[2*k+1]*g[2*m+1]*alpha[index] + g[2*k+1]*h[2*m+1]*beta[index] +
	    h[2*k+1]*g[2*m+1]*gamma[index] + h[2*k+1]*h[2*m+1]*s[index];
	}
    }
}


/*****************************************************************************/

/* Input and output arguments */

#define	ALPHA_IN prhs[0]
#define BETA_IN prhs[1]
#define GAMMA_IN prhs[2]
#define S_IN prhs[3]

#define	H_IN prhs[4]
#define	G_IN prhs[5]

#define	S_OUT plhs[0]


/****************************************************************************/

void mexFunction(
	 int nlhs,
	 mxArray *plhs[],
	 int nrhs,
	 const mxArray *prhs[])
{
  double *alpha, *beta, *gamma, *s, *h, *g;
  double *sout;
  unsigned int N, M, mask;

  /* Check for proper number of arguments */

  if (nrhs != 6) mexErrMsgTxt("fwt2step requires six input arguments.");
  if (nlhs != 1) mexErrMsgTxt("fwt2step requires one output argument.");
  
  /* Check the dimensions of input parameters */
  
  if ((mxGetN(S_IN) != mxGetM(S_IN)) || (mxGetN(ALPHA_IN) != mxGetM(ALPHA_IN))
      || (mxGetN(BETA_IN) != mxGetM(BETA_IN)) || (mxGetN(GAMMA_IN) != mxGetM(GAMMA_IN)))
    mexErrMsgTxt ("Input matrices must be square.");
  if ((mxGetN(S_IN) != mxGetN(ALPHA_IN)) || (mxGetN(S_IN) != mxGetN(BETA_IN))
      || (mxGetN(S_IN) != mxGetN(GAMMA_IN)))
    mexErrMsgTxt ("Input matrices must be of the same size.");
  N = mxGetN(S_IN);
  mask = N - 1;

  M = max (mxGetM(H_IN), mxGetN(H_IN)) / 2;
  if (max (mxGetM(G_IN), mxGetN(G_IN)) / 2 != M)
    mexErrMsgTxt ("Input vectors h and g must be of the same length.");
  if ((mxGetM(H_IN) != 1) && (mxGetN(H_IN) != 1) ||
      (mxGetM(G_IN) != 1) && (mxGetN(G_IN) != 1)) 
    mexErrMsgTxt ("Input arguments h and g must be vectors.");

  /* Create matrices for the return arguments */
  
  S_OUT = mxCreateDoubleMatrix (2*N, 2*N, mxREAL);
  
  /* Assign pointers to the various parameters */
  
  sout = mxGetPr(S_OUT);
  h = mxGetPr(H_IN);
  g = mxGetPr(G_IN);
  alpha = mxGetPr(ALPHA_IN);
  beta = mxGetPr(BETA_IN);
  gamma = mxGetPr(GAMMA_IN);
  s = mxGetPr(S_IN);
  
  /* Do the actual computations */
  
  ifwt2step (sout, h, g, alpha, beta, gamma, s, N, M, mask);
}
