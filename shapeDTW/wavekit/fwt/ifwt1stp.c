/*
  Inverse fast wavelet transform (1-dimensional), non-standard form

  sout = ifwt1stp(s,d,h,g)

  s,d   smooth and detail data
  h,g   scaling function and wavelet filter coefficients
  sout  smooth data at next level

  For matlab 5.1

  (C) 1993-1997 Harri Ojanen
*/

#include <math.h>
#include "mex.h"

#define	max(A, B)	((A) > (B) ? (A) : (B))

/*****************************************************************************/

void ifwt1stp (
	       double s[],
	       double d[],
	       double h[],
	       double g[],
	       double sout[],
	       unsigned int N,
	       unsigned int M,
	       unsigned int mask)
{
  unsigned int n, k;
  unsigned int index;

  for (n = 0; n < N; n++) {
    sout [2*n+1] = 0.0;
    sout [2*n] = 0.0;
    for (k = 0; k < M; k++) {
      index = (n-k) & mask;
      sout [2*n+1] += h[2*k+1] * s[index] + g[2*k+1] * d[index];
      sout [2*n] += h[2*k] * s[index] + g[2*k] * d[index];
    }
  }
}


/*****************************************************************************/

/* Input and output arguments */

#define	S_IN prhs[0]
#define	D_IN prhs[1]
#define	H_IN prhs[2]
#define	G_IN prhs[3]

#define	S_OUT plhs[0]


/****************************************************************************/

void mexFunction(
	 int nlhs,
	 mxArray *plhs[],
	 int nrhs,
	 const mxArray *prhs[])
{
  double *s, *d, *h, *g;
  double *sout;
  unsigned int N, M, mask;

  /* Check for proper number of arguments */

  if (nrhs != 4) mexErrMsgTxt("ifwt1stp requires four input arguments.");
  if (nlhs != 1) mexErrMsgTxt("ifwt1stp requires one output argument.");
  
  /* Check the dimensions of input parameters */
  
  N = max (mxGetN(S_IN), mxGetM(S_IN));
  if (max (mxGetM(D_IN), mxGetN(D_IN)) != N)
    mexErrMsgTxt ("Input vectors s and d must be of the same length.");

  mask = max (mxGetN(S_IN), mxGetM(S_IN)) - 1;

  M = max (mxGetM(H_IN), mxGetN(H_IN)) / 2;
  if (max (mxGetM(G_IN), mxGetN(G_IN))/2 != M)
    mexErrMsgTxt ("Input vectors h and g must be of the same length.");
  if ((mxGetM(H_IN) != 1) && (mxGetN(H_IN) != 1) ||
      (mxGetM(G_IN) != 1) && (mxGetN(G_IN) != 1)) 
    mexErrMsgTxt ("Input arguments h and g must be vectors.");

  /* Create matrices for the return arguments */
  
  S_OUT = mxCreateDoubleMatrix (2*N, 1, mxREAL);
  
  /* Assign pointers to the various parameters */
  
  s = mxGetPr(S_IN);
  d = mxGetPr(D_IN);
  h = mxGetPr(H_IN);
  g = mxGetPr(G_IN);
  sout = mxGetPr(S_OUT);
  
  /* Do the actual computations */
  
  ifwt1stp (s, d, h, g, sout, N, M, mask);
}
