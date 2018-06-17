totalEmission <- aggregate(Emissions ~ year, NEIdata, sum)
totalEmission
barplot(
  (totalEmission$Emissions)/10^6,
  names.arg=totalEmission$year,
  xlab="Year",
  ylab="PM2.5 Emissions (10^6 Tons)",
  main="Total PM2.5 Emissions From All US Sources"
)
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()

