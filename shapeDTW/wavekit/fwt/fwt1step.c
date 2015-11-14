/*
  Fast wavelet transform (1-dimensional), non-standard form
  One iteration step

  [sout,d] = fwt1step(s,h,g)

  s        original data
  h, g     scaling function and wavelet filter coefficients
  sout, d  'smooth' and 'detail' coefficients at next level

  Used as a subprogram by fwt1ns.

  For matlab 5.1

  (C) 1993-1997 Harri Ojanen
*/

#include <math.h>
#include "mex.h"

#define	max(A, B)	((A) > (B) ? (A) : (B))

/*****************************************************************************/

void fwt1step (
	       double s[],
	       double h[],
	       double g[],
	       double sout[],
	       double dout[],
	       unsigned int N,
	       unsigned int M,
	       unsigned int mask)
{
  unsigned int n, k;
  unsigned int index;

  for (k = 0; k < N; k++) {
    sout [k] = 0.0;
    dout [k] = 0.0;
    for (n = 0; n < M; n++) {
      index = (n+2*k) & mask;
      sout [k] += h[n] * s[index];
      dout [k] += g[n] * s[index];
    }
  }
}


/*****************************************************************************/

/* Input and output arguments */

#define	S_IN prhs[0]
#define	H_IN prhs[1]
#define	G_IN prhs[2]

#define	S_OUT plhs[0]
#define D_OUT plhs[1]


/****************************************************************************/

void mexFunction(
	 int nlhs,
	 mxArray *plhs[],
	 int nrhs,
	 const mxArray *prhs[])
{
  double *s, *h, *g;
  double *sout, *dout; 
  unsigned int N, M, mask;


  /* Check for proper number of arguments */

  if (nrhs != 3) mexErrMsgTxt("fwt1step requires three input arguments.");
  if (nlhs != 2) mexErrMsgTxt("fwt1step requires two output arguments.");
  

  /* Check the dimensions of input parameters */

  if ((mxGetM(S_IN) != 1) && (mxGetN(S_IN) != 1))
    mexErrMsgTxt("Input argument s must be a vector.");
  N = max (mxGetN(S_IN), mxGetM(S_IN)) / 2;
  if (2*N != max (mxGetN(S_IN), mxGetM(S_IN)))
    mexErrMsgTxt("Input vector s must have even length.");

  mask = max (mxGetN(S_IN), mxGetM(S_IN)) - 1;

  M = max (mxGetM(H_IN), mxGetN(H_IN));
  if (max (mxGetM(G_IN), mxGetN(G_IN)) != M)
    mexErrMsgTxt ("Input vectors h and g must be of the same length.");
  if ((mxGetM(H_IN) != 1) && (mxGetN(H_IN) != 1) ||
      (mxGetM(G_IN) != 1) && (mxGetN(G_IN) != 1)) 
    mexErrMsgTxt ("Input arguments h and g must be vectors.");
  

  /* Create matrices for the return arguments */
  
  S_OUT = mxCreateDoubleMatrix (N, 1, mxREAL);
  D_OUT = mxCreateDoubleMatrix (N, 1, mxREAL);
  

  /* Assign pointers to the various parameters */
  
  s = mxGetPr(S_IN);
  h = mxGetPr(H_IN);
  g = mxGetPr(G_IN);
  sout = mxGetPr(S_OUT);
  dout = mxGetPr(D_OUT);
  
  
  /* Do the actual computations */
  
  fwt1step (s, h, g, sout, dout, N, M, mask);
}
