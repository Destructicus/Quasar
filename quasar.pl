#use strict;
use warnings;

# Generic Counters
my $cnt1 = 0;
my $cnt2 = 0;

my $QCannonDefault_Fuel = 1000000;
my $QCannons = 5;

my @QCannon_Sector = (10,10,10,10,10);
my @QCannon_Atmo = (10,10,10,10,10);
my @QCannon_MaxFuel = ($QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel);
my @QCannon_Fuel = ($QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel,$QCannonDefault_Fuel);

my @QCannon_test = (0,0,0,0,0);
my @QCannon_Best = (0,0,0,0,0);
my $ShipsKilled = 0;
my $RecordShipsKilled = 0;

my $ShipMaxFigs = 50000;
my $ShipMaxShields = 2000;
my $ShipFigs = 50000;
my $ShipShields = 2000;

my $BlastDamage = 0;
my $RoundDamage = 0; 		# A round is defined as all quasars firing in sequence
my $IncursionDamage = 0;	# An incursion is one entry by one ship, and may include multiple rounds
my $TotalDamage = 0;		# Total Damage is the damage incurred over all incursions

my $FuelUsed = 0;
my $TotalFuelUsed = 0;
my $RecordFuelUsed = 1000000;

my $NowTime = 0;
my $StartTime = 0;
my $Timeleft = 0;
my $Remaining  = 0;
my $Completed = 0;

# Incursion
#
# Handles one entry into sector by one ship.
# Arguments:
#   ShipType
#   ShipFigs
#   ShipShields
#
#
# Returns:
#   Returns 1 if entering ship was destroyed
#   Returns 2 if entering ship survives
sub Incursion {
	

}

# BlastRound
#
# Fires all quasars in the sector
# Arguments:
#
# Returns:
#   Returns 1 if ship was destroyed
#   Returns 0 if ship survived
sub BlastRound {
	$RoundDamage = 0;
	$FuelUsed = 0;
	$cnt2 = 0;
	while ($cnt2 < $QCannons) {
		$BlastDamage = SectorBlast($cnt2);
		$RoundDamage += $BlastDamage;
		$FuelUsed += $BlastDamage * 3;
		#print "Damage this round: ", $RoundDamage, "\n";
		if ($RoundDamage > ($ShipFigs + $ShipShields)) {
			# print "The invader has been destroyed!\n";
			$cnt2 = $QCannons;
			return 1;
		}
		$cnt2++;
	}
	return 0;
}

# AtmoBlast
#
# Handles one Atmo blast from one quasar
# Arguments:
#
#
# Returns:
# 
#
sub AtmoBlast {

}

# SectorBlast
#
# Handles one Sector blast from one quasar
# Arguments:
#
#
# Returns:
# 
#
sub SectorBlast {
	my $PlanetID = shift;
	my $Damage = int($QCannon_Fuel[$PlanetID] * $QCannon_Sector[$PlanetID] / 300);
	$QCannon_Fuel[$PlanetID] -= $Damage * 3;
	# print "Planet ", $PlanetID+1, " fires!\n";
	# print "Fuel spent: ", $Damage * 3, "\n";
	# print "Blast amount: ", $Damage, "\n";
	return $Damage;
}


# Menu
#
# Handles user options
# Arguments:
#
# Returns:
#   Returns 0 if user wishes to end program
#   
sub Menu {
	my $UserInput = 1;
	while ($UserInput != 0) {
		print " (1) Define number of quasars (default is 5)\n";
		print " (2) Define fuel levels of planets (default is ", $QCannonDefault_Fuel, ") \n";
		print " (3) Define QCannon levels (default is 10)\n";
		print " (4) Define Invasion Ship (Default is ISS, 50,000 figs + 2000 shields)\n";
		print " (5) Invade!\n";
		print " (6) Find Optimal Levels.\n";
		print " (7) Reset fuel levels\n";
		print " (X) Exit\n";
		print "Select an option: ";
		$UserInput = int(<stdin>);
		if ($UserInput == "1") {	DefinePlanets(); }
		elsif ($UserInput == "2") {	DefineFuel(); }
		elsif ($UserInput == "3") {	}
		elsif ($UserInput == "4") {	}
		elsif ($UserInput == "5") {	BlastRound(); }
		elsif ($UserInput == "6") {	TestCases(); }
		elsif ($UserInput == "7") {	TimeTest(); }
		else {	$UserInput = 0; }
	}
	
}

# DefinePlanets
#
# Allows user to specify number of planets with quasars.
sub DefinePlanets {
	print "Enter number of quasars in sector: ";
	$QCannons = int(<stdin>);
	print $QCannons, " quasars, confirmed.\n\n";
	$cnt1 = 0;
}

# DefineFuel
#
# Allows user to define fuel levels on each planet
sub DefineFuel {
	while ($cnt1 < $QCannons) {
		print "Enter fuel amount for quasar ", $cnt1+1, ": ";
		$QCannon_Fuel[$cnt1] = int(<stdin>);
		print "Enter sector level for quasar ", $cnt1+1, ": ";
		$QCannon_Sector[$cnt1] = int(<stdin>);
		print "Enter atmo level for quasar ", $cnt1+1, ": ";
		$QCannon_Atmo[$cnt1] = int(<stdin>);
		$cnt1++;
	}

}


my $QIncrement = 3;
# TestCases
#
# For the defined number of planets and defined fuel levels, determines maximum quasar settings to
# prevent ships from gaining entry into sector.
sub TestCases {
	my $ShipWasKilled = 1;
	$StartTime = time;
	$OriginalTime = $StartTime;
	while ($QCannonTest[0] < 100) {
		$QCannonTest[0] += $QIncrement;
		print "Testing: ", $QCannonTest[0];
		$QCannonTest[1] = 0;
		$QCannonTest[2] = 0;
		$QCannonTest[3] = 0;
		$QCannonTest[4] = 0;
		while ($QCannonTest[1] < 100) {
			$QCannonTest[1] += $QIncrement;
			$QCannonTest[2] = 0;
			$QCannonTest[3] = 0;
			$QCannonTest[4] = 0;
			
			$Time1 = time;
			$TimeElapsed = $Time1 - $OriginalTime;
			$Completed = (100 * ($QCannonTest[0] - 1)) + $QCannonTest[1];
			$Remaining = 10001 - $Completed;
			$TimeLeft = $TimeElapsed * $Remaining / $Completed;
			$HoursLeft = int($TimeLeft / (60 * 60));
			$MinutesLeft = int(($TimeLeft - ($HoursLeft * 60 * 60)) / 60);
			$SecondsLeft = int($TimeLeft - ($HoursLeft * 60 * 60) - ($MinutesLeft * 60));
			if ($Completed % 50 == 1) {
				print "Completed: ", $Completed, "\n";
				print "Elapsed: ", $TimeElapsed, "\n";
				print "Time Left: ", $HoursLeft, ":", $MinutesLeft, ":", $SecondsLeft, "\n";
			}
			while ($QCannonTest[2] < 100) {
				$QCannonTest[2] += $QIncrement;
				$QCannonTest[3] = 0;
				$QCannonTest[4] = 0;
				while ($QCannonTest[3] < 100) {
					$QCannonTest[3] += $QIncrement;
					$QCannonTest[4] = 0;
					while ($QCannonTest[4] < 100) {
						$QCannonTest[4] += $QIncrement;		
						
						# print $RecordShipsKilled, " - Testing : ", $QCannonTest[0], "/", $QCannonTest[1], "/", $QCannonTest[2], "/", $QCannonTest[3], "/", $QCannonTest[4], "\n";
						# @QCannon_Fuel = (94111,97286,170973,90476,0); # 12/20/2010
						@QCannon_Fuel = (112000,114000,189000,107000,43000); # 12/20/2010
						# @QCannon_Fuel = (150000,150000,250000,150000,0); # 12/20/2010
						# @QCannon_Fuel = (161000,174000,265000,168000,48000) # 12/29/2010
						# Test Comment
						$TotalFuelUsed = 0;
						$QCannon_Sector[0] = $QCannonTest[0];
						$QCannon_Sector[1] = $QCannonTest[1];
						$QCannon_Sector[2] = $QCannonTest[2];
						$QCannon_Sector[3] = $QCannonTest[3];
						$QCannon_Sector[4] = $QCannonTest[4];
						$ShipsKilled = 0;
						$ShipWasKilled = 1;
						while ($ShipWasKilled == 1) {
							$ShipWasKilled = BlastRound();
							$TotalFuelUsed += $FuelUsed;
							$ShipsKilled += $ShipWasKilled;
							if ($ShipsKilled > $RecordShipsKilled) {
								@QCannonBest = @QCannonTest;
								$RecordShipsKilled = $ShipsKilled;
								$RecordFuelUsed = $TotalFuelUsed;
								print "\n\nShips destroyed: ", $ShipsKilled, "\n";
								print "Total Fuel Used: ", $TotalFuelUsed, "\n";
								print "Planet 1: ", $QCannonTest[0], "\n";
								print "Planet 2: ", $QCannonTest[1], "\n";
								print "Planet 3: ", $QCannonTest[2], "\n";
								print "Planet 4: ", $QCannonTest[3], "\n";
								print "Planet 5: ", $QCannonTest[4], "\n";
							}
							if ($ShipsKilled == $RecordShipsKilled)  {
								if ($TotalFuelUsed < $RecordFuelUsed) {
									@QCannonBest = @QCannonTest;
									$RecordShipsKilled = $ShipsKilled;
									$RecordFuelUsed = $TotalFuelUsed;
									print "\n\nShips destroyed: ", $ShipsKilled, "\n";
									print "New minimum fuel found.\n";
									print "Total Fuel Used: ", $TotalFuelUsed, "\n";
									print "Planet 1: ", $QCannonTest[0], "\n";
									print "Planet 2: ", $QCannonTest[1], "\n";
									print "Planet 3: ", $QCannonTest[2], "\n";
									print "Planet 4: ", $QCannonTest[3], "\n";
									print "Planet 5: ", $QCannonTest[4], "\n";
								}
							}
						}
					}
				}
			}
		}			
	}
}

Menu;


