Meta Analysis Funnel plot of Odds ratio vs Standard Error

The more useful plot is the log of the odds ration versus the SE of the log
of the odds ratio. Sample size is also useful for y axis.


see
https://goo.gl/P1XmoA
https://communities.sas.com/t5/SAS-GRAPH-and-ODS-Graphics/Funnel-plot-Odds-ratio-vs-Standard-Error/m-p/421760


INPUT
=====

 SD1.HAVE total obs=38

                         EVENTS              EVENTS
   STUDY    TRT_N    TRT_MI    CTRL_N    CTRL_MI

    M01       357       2        176         0
    M02       391       2        207         1
    M03       774       1        185         1
    M04       213       0        109         1
    M05       232       1        116         0
    M06        43       0         47         1

 ...


WORKING CODE
============

   want<-metabin(event.e, n.e, event.c, n.c,sm="OR",keepdata=TRUE);
   funnel(trimfill(want));

OUTPUT
=====

 Standard Error
      |
  0.0 +
      |                         /\
      |                        /  \
      |                       / *  \
      |                      /      \
      |                     /        \
      |                    /        * \
  0.5 +                   /            \
      |                  /              \
      |                 /                \
      |                /                  \
      |               /                    \
      |              /                   *  \
      |             /    *                   \
  1.0 +            /                          \
      |           /                       *    \
      |          /                              \
      |         /      *     **         *        \
      |        /                                  \
      |       /                                    \
      |      /       *  *                           \
  1.5 +     /                                        \
      |    /       *            *            ** *     \
      |   /         * D   * **    **          *   * *  \
      |  /
      |
  2.0 +
      -+----------+----------+----------+----------+----------+-
      -1          0          1          2          3          4

                               OR


WORK.WANTWPS  OBS=38


  EVENT_E  N_E  EVENT_C  N_C  INCR_E  INCR_C  STUDLAB     TE       SETE

     2     357     0     176    0.5     0.5       1     0.90923  1.55193
     2     391     1     207    0.0     0.0       2     0.05744  1.22777
     1     774     1     185    0.0     0.0       3    -1.43534  1.41659
     0     213     1     109    0.5     0.5       4    -1.77550  1.63724
     1     232     0     116    0.5     0.5       5     0.41192  1.63694
     0      43     1      47    0.5     0.5       6    -1.03192  1.64656

    LOWER      UPPER       ZVAL        PVAL     W_FIXED    W_RANDOM

  -2.13249    3.95096     0.58587    0.55796    0.33224     0.41520
  -2.34895    2.46383     0.04679    0.96268    0.65050     0.66338
  -4.21181    1.34112    -1.01324    0.31095    0.80605     0.49832
  -4.98444    1.43344    -1.08444    0.27817    0.98843     0.37306
  -2.79642    3.62027     0.25164    0.80132    0.33071     0.37319
  -4.25912    2.19528    -0.62671    0.53085    0.70924     0.36885

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data sd1.have;
input study$ trt_n trt_mi ctrl_n ctrl_mi @@;
cards4;
M01 357 2 176 0 M02 391 2 207 1 M03 774 1 185 1 M04 213 0 109 1
M05 232 1 116 0 M06 43 0 47 1 M07 121 1 124 0 M08 110 5 114 2
M09 382 1 384 0 M10 284 1 135 0 M11 294 0 302 1 M12 563 2 142 0
M13 278 2 279 1 M14 418 2 212 0 M15 395 2 198 1 M16 203 1 106 1
M17 104 1 99 2 M18 212 2 107 0 M19 138 3 139 1 M21 122 0 120 1
M22 175 0 173 1 M23 56 1 58 0 M24 39 1 38 0 M25 561 0 276 2
M26 116 2 111 3 M27 148 1 143 0 M28 231 1 242 0 M29 89 1 88 0
M30 168 1 172 0 M32 1172 1 377 0 M34 204 1 185 2 M35 288 1 280 0
M36 254 1 272 0 M37 314 1 154 0 M39 442 1 112 0 M40 394 1 124 0
M41 2635 15 2634 9 M42 1456 27 2895 41
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
libname hlp sas7bdat "C:\Program Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
library(haven);
library(meta);
have<-read_sas("d:/sd1/have.sas7bdat");
event.e <- have$TRT_MI ;
event.c <- have$CTRL_MI;
n.e     <- have$TRT_N  ;
n.c     <- have$CTRL_N;
want<-metabin(event.e, n.e, event.c, n.c,sm="OR",keepdata=TRUE);
png("d:/png/funnel.png");
funnel(trimfill(want));
endsubmit;
import r=want data=wrk.wantwps;
run;quit;
');

*               _ _         _       _
  __ _ ___  ___(_|_)  _ __ | | ___ | |_
 / _` / __|/ __| | | | '_ \| |/ _ \| __|
| (_| \__ \ (__| | | | |_) | | (_) | |_
 \__,_|___/\___|_|_| | .__/|_|\___/ \__|
                     |_|
;
data fix;
 set wantwps;
  seTe=-1*seTe;
  or=exp(te);
  keep seTe or;
run;quit;

options ls=64 ps=40;
proc plot data=fix;
plot seTE*or/haxis=-1 to 4 by 1 ;
run;quit;



