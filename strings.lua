function data()
	return {
	de = {		
		title = "Förster",
        description = "Kann zum Aufforsten großer Flächen genutzt werden.\n\z
		-----------------------------------------\n\z
		\n\z
		Schritt 1: Im Modus 'Planen' den Umriss des Waldstücks festlegen.\n\z		
		Schritt 2: Gewünschte Dichte und Baumart festlegen.\n\z		
		Schritt 3: Mit einem Klick auf 'Pflanzen' das Waldstück anlegen.\n\z
		-----------------------------------------\n\z
		\n\z
		WARNUNG: Mit Hilfe dieses Werkzeugs lassen sich eine MENGE Bäume pflanzen. Werden große Flächen auf einmal begrünt, kann das einige Sekunden dauern, bis zu mehreren Minuten, falls die ganze Karte begrünt wird. Es gibt gute Gründe warum das Spiel normalerweise relativ wenige Bäume generiert.\n\z
		\n\z
		HINWEIS: Die Performance des Tools verringert sich, wenn sich bereits sehr viele Assets auf der Karte befinden, z.B. Bäume. Die Bäume des Försters, sowie jene die beim Erstellen der Karte generiert wurden, zählen nicht dazu.",
		mode = "Modus",
		density = "Dichte (m² / Baum)", 
		type = "Typ",
		plan = "Planen",
		plant = "Pflanzen",
		reset = "Zurücksetzen",
		all = "Alle",
		conifer = "Nadelbaum",
		broadleaf = "Laubbaum",
		shrub = "Busch",
		patch_title = "NICHT BENUTZEN",
		patch_description = "Sub-Asset für den Förster. Nur Sichtbar wegen dem 'All available' Mod.",
		
	},
	en = {
	title = "Forester",
	description = "Can be used to reforest large areas.\n\z	
	-----------------------------------------\n\z
	\n\z
	Step 1: Set the outline of the forest in 'plan' mode.\n\z	
	Step 2: Specify desired density and tree species.\n\z	
	Step 3: Create the forest with a click on 'plant'.\n\z	
	-----------------------------------------\n\z
	\n\z
	WARNING: This tool will allow you to create a LOT of trees. Planting a lot of trees at once might take a few seconds, up to minutes, in case you make the whole map green. The game performance will suffer. There's a good reason why games are not created with many trees initially.\n\z 
	\n\z
	HINT: The performance of the tool suffers in case you already added a lot of assets to your map, e.g. trees. The trees that are created by the forester or at the time of map creation have no bigger impact though.", 
	mode = "mode",
	type = "type",
	plan = "plan",
	plant = "plant",
	reset = "reset",
	all = "all",
	conifer = "conifer",
	broadleaf = "broadleaf",
	shrub = "shrub",
	patch_title = "DO NOT USE",
	patch_description = "Sub-asset for the forester. Only visible because of your 'All available' mod.",
	},
}
end