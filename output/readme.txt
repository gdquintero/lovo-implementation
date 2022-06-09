Esta carpeta contiene todas las salidas de las rutinas implementadas. 

	days.txt: Número de días considerados en el ajuste

	data.txt: Número de muertos (new per day/7-day-rolling-average) de los días considerados

	data2.txt: Número de muertos de los siguientes días (25 días)

	xstarL1.txt: Solución minimizando la norma L1

	xstarLinf.txt: Solución minimizando la norma Linf

	xstarleastsquares.txt: Solución usando mínimos cuadrados

	xstarlovo.txt: Solución minimizando la función LOVO

	xstarovo.txt: Solución usando OVO



Los siguientes archivos son usados para plotar usando GNUPLOT:

	plotdata.txt: 
		Columna 1: días
		Columna 2: número de muertos (new per day/7-day-rolling-average)
		
	plotsolutions:
		Columna 1: ordinate
		Columna 2: ovo
		Columna 3: lovo
		Columna 4: lq
		Columna 5: l1
		Columna 6: linf
