#define ASCII_MATRIX	 (0x2e4d4154)	/* '.MAT' */
#include <stdlib.h>
#include <stdio.h>
#include "torchstuff.h"

/*************************************************************************/


double **ReadInputFile(char *filename, int *cols, int *rows) {
  int j,k;
 FILE *f;
 double **A;
 f=fopen(filename,"r");
 if (f==NULL) {
   *cols = -1;
   printf("file not found\n");
   return(NULL);
}
 fscanf(f,"%d ",rows); /* read number of points */
 fscanf(f,"%d\n",cols); /* read cols */
 A = (double **)malloc((*rows)*sizeof(double *));
 for (k=0; k < *rows; k++) {
   A[k] = (double *)malloc((*cols)*sizeof(double));
 }

 for (k=0;k<*rows;k++) {
   for (j=0; j < *cols; j++) {
     fscanf(f,"%lf\n",&A[k][j]);
   }
 }
 fclose(f);
 return(A);
}

/* This is pseudo code; I have no idea how to do this yet */
TH_API void *GetDoubleTensorFromFile(char *filename) {
  int i,j;
  double **A;
  TH_API void *B;
  A = ReadInputFile(filename,i,j);
  B = DeepCopyTHTensor(A,i,j);
  free(A);
  return B;
}
 
