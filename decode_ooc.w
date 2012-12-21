\datethis
@* Introduction. BLAT is a program wrote by Jim Kent to perform fast mRNA-DNA alignment. 
k-mer (k from 6 to 18), or tileSize,  is the size of the index  used to index the genome. 
The k-mer is converted to an integer first. It is optional for user to generate a file including
all extremely high frequency tile, called ooc file. The file is encoded by a binary format
which has first 32bit as sig, second 32bit as k-mer size, then each 32bit is the
overused tile. This program is designed to convert the tile, which is an integer
number, to a 11 mer DNA sequence. 


@p
#include <stdio.h>
@<Global variables@>@;
@#
void main(int argc, char **argv){
  int tileSize=11;
  int n, p, q, i,t;
  char buf[256];
  char *s;


  s = (char *) malloc( (tileSize+1)*sizeof(char)); /* memory for converted k-mer */
  s[tileSize+1]='\0';

  @<convert from ooc file@>@;

  exit(0);
}


@ @<Global...@>=
char bases[4]={'T','C','A','G'};


@* Convert from ooc file. 
Let's decode ooc from original ooc file, which is encoded in a binary format
starting with 32bit sig, 32bit k-mer, then each 32bit is a number.

@<convert from ooc file@>=
FILE  *fp = fopen(argv[1],"r+b");
if ( fp == NULL ) {
   printf("fopen error %s",argv[0]);
   exit(0);
}

/* sig and k-mer */
fread(&n,sizeof(int),1,fp);
fread(&n, sizeof(int), 1, fp);

while ( feof(fp) == 0  ) {
      fread(&n,sizeof(int),1,fp);
      t = n;
      for(i=0;i<tileSize;i++){
        q = n % 4;
        n = n / 4;
        s[tileSize-1-i]=bases[q];
        }
        printf("%d %s\n",t, s);
}

fclose(fp);





@* Optional.  
Convert Tile from integer to DNA sequence. K-mer is used to index the DNA sequence. In BLAT,
base T is assigned 0, C is 1, A is 2, and G is 3. Thus a sequence TC can be converted to 
0*4+1 = 1. and TCC can be converted to 1*4+1=5. 

@<convert tile from integer to DNA@>=
while ( fgets(buf,255,stdin) ){
    n = atoi(buf);
    for(i=0;i<tileSize;i++){
      q = n % 4;
      n = n / 4;
      s[tileSize-1-i]=bases[q];
    }
    printf("%s\n",s);
}
