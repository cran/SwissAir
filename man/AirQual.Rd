\name{AirQual}
\alias{AirQual}
\docType{data}
\title{Air Quality Data of Switzerland for 2004 in 30 min Resolution}
\description{
  Dataset contains Ozone (=O3), Sum of Nitrogenmonoxide and
  Nitrogendioxide (=NOx), Nitrogenmonoxid (=NO),
  ambient temperature (T), dew point (Td), wind speed (WS) and
  wind direction (WD) at 3 sites around lake of Lucerne in Central
  Switzerland in 30 min time resolution for the year 2004.
}

\usage{data(AirQual)}

\format{
  A data frame with 17568 observations on the following 22 variables.
  \describe{
    \item{\code{start}}{start time of measurement}
    \item{\code{ad.O3}}{Mean concentration [ppb] of O3 in ad}
    \item{\code{ad.NOx}}{Mean concentration [ppb] of NOx in ad}
    \item{\code{ad.NO}}{Mean concentration [ppb] of NO in ad}
    \item{\code{ad.WS}}{Wind speed [m/s] in ad}
    \item{\code{ad.WD}}{Wind direction in ad}
    \item{\code{ad.T}}{Mean ambient temperature [°C] in ad}
    \item{\code{ad.Td}}{Mean dew point [°C] in ad}
    \item{\code{lu.O3}}{Mean concentration [ppb] of O3 in sz}
    \item{\code{lu.NOx}}{Mean concentration [ppb] of NOx in sz}
    \item{\code{lu.NO}}{Mean concentration [ppb] of NO in sz}
    \item{\code{lu.WS}}{Wind speed [m/s] in sz}
    \item{\code{lu.WD}}{Wind direction in sz}
    \item{\code{lu.T}}{Mean ambient temperature [°C] in sz}
    \item{\code{lu.Td}}{Mean dew point [°C] in sz}
    \item{\code{sz.O3}}{Mean concentration [ppb] of O3 in sz}
    \item{\code{sz.NOx}}{Mean concentration [ppb] of NOx in sz}
    \item{\code{sz.NO}}{Mean concentration [ppb] of NO in sz}
    \item{\code{sz.WS}}{Wind speed [m/s] in sz}
    \item{\code{sz.WD}}{Wind direction in sz}
    \item{\code{sz.T}}{Mean ambient temperature [°C] in sz}
    \item{\code{sz.Td}}{Mean dew point [°C] in sz
    }
  }
}

\details{
  The 3 sites are
  \describe{
    \item{ad  }{Site in Altdorf is located 100 m east of motorway A2 from
      Bale to Chiasso, on an open field at the beginning of a more than
      2000 m deep valley, at 438 m altitude.}
    \item{lu  }{Site is located in Sedel next to town of Lucerne 35m above
      and 250m south of motorway A14 on a small hill with free 360°
      panorama at 484 m altitude.}  
    \item{sz  }{Site is located in Schwyz in an aerea of medium density of
      buildings next to a shopping center.}
  }
  
  NO and O3 react in the atmosphere within seconds to NO2. The
  production and destruction of the sum of O3 and NO2 (=Ox) takes place
  on a much lower time scale, so that the spatial (cf. ipairs output)
  and temporal (cf. ilagplot) correlation of Ox is much more pronounced
  than the correlation of O3 or NO.
}

\source{
  The data are collected by inNet corporation
  \url{http://www.innetag.ch/} on behalf of in-Luft, an association for
  air quality controle, of the Swiss Cantons Aargau, Luzern, Nidwalden,
  Obwalden, Schwyz, Uri und Zug \url{http://www.in-luft.ch/}.
}

\references{
Rene Locher, Andreas Ruckstuhl; Plausibilisierung von Ozon, Stickoxiden
und PM10: Statistische Methoden zur Effizienz- und Qualitätssteigerung
der Messdatenplausibilisierung; inLuft 2003;
  \url{http://www.idp.zhwin.ch/geschaeftsfelder/docs/Plausibilisierung_O3_NOx_PM10.zip} 
}

\seealso{
For viewing large datasets see \code{library(IDPmisc)}
  }

  \examples{
data(AirQual)
str(AirQual)
sapply(AirQual,function(x) sum(is.na(x)))
cbind(min=sapply(AirQual[,-1], min, na.rm=TRUE),
      median=sapply(AirQual[,-1], median, na.rm=TRUE),
      max=sapply(AirQual[,-1], max, na.rm=TRUE))

if(require(IDPmisc)) {

  ## low correlation, density on logarithmic scale
  ipairs(AirQual[,c("ad.O3","lu.O3","sz.O3")],
         ztrans=function(x){x[x<1] <- 1; log2(x)*10})
  ipairs(AirQual[,c("ad.NO","lu.NO","sz.NO")],
         ztrans=function(x){x[x<1] <- 1; log2(x)*10})
  ilagplot(AirQual[,c("ad.O3")],set.lags = 1:9,
         ztrans=function(x){x[x<1] <- 1; log2(x)*10})

  Ox <- AirQual[,c("ad.O3","lu.O3","sz.O3")]+
        AirQual[,c("ad.NOx","lu.NOx","sz.NOx")]-
        AirQual[,c("ad.NO","lu.NO","sz.NO")]
  names(Ox) <- c("ad","lu","sz")

  ## high correlation, density on logarithmic scale
  ipairs(Ox,
         ztrans=function(x){x[x<1] <- 1; log2(x)*10})
  ilagplot(Ox$ad,set.lags = 1:9,
         ztrans=function(x){x[x<1] <- 1; log2(x)*10})

  dat <-
    data.frame(month =as.numeric(
                 substr(levels(AirQual$start)[AirQual$start],4,5)),
               hour = as.numeric(
                 substr(levels(AirQual$start)[AirQual$start],
                        12,13)),
               WD = AirQual$ad.WD,
               NOx = AirQual$ad.NOx,
               O3  = AirQual$ad.O3,
               Ox  = AirQual$ad.O3+AirQual$ad.NOx-AirQual$ad.NO)

    med.dayrose <- rose(dat[,c("NOx","O3","Ox")],
                      subset= dat$month>4 & dat$month<10,
                      cyclVar=dat$hour, n.cyclVar=24, circle=24,
                      FUN=median, na.rm=TRUE)

  ## NOx (= NO+NO2) and ozone (O3) have a distinct diurnal variation of
  ## concentration, whereas Ox (= NO2+O3) varies only very slightly
  grid.newpage()
  plot(med.dayrose,
       general = general.control(lwd=2),
       grid =
       grid.control(ray.n = 12,
                    circ.n =2,
                    circ.sub.n = 2,
                    cyclVar.lab = seq(0,by=2,to=22)),
       title = title.control(text=
         "Day Rose of Medians\nduring summer time"))
} else print("Package IDPmisc is not available")
}

\keyword{datasets}
