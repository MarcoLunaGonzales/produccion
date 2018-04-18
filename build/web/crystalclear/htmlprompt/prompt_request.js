
//--------------------------------------- CheckAll & CheckPrompt---------------------------------------
var alerts;
var lastSelectedPrompt = 0;

/*
* If you click on the submit button, it checks the selected prompt
* if he has no error, the document will be submited
*/
function checkAll(){
	alerts = '';
	for (var i=0 ; i < prompts.length ; i++)
	{
		checkPrompt(i);
	}
	if (alerts.length > 1){
		alert(unescape(alerts));
    } else {
	    multiToPrompt();
    	document.check.submit();
    }
}


/*
* This function validates the prompt values 
*/
function checkLastPrompt(){
	alerts = '';
	checkPrompt(lastSelectedPrompt);

	if (alerts.length > 1){
		document.getElementById("SelectPrompt").selectedIndex = lastSelectedPrompt;
		alert(unescape(alerts));
    } else {
		setTable();
	}
}


/*
* This function validates the prompt values 
*/
function checkPrompt(index){
	if (prompts[index].discrete == true){
		checkDiscrete(index);
	}
	if (prompts[index].range == true){
		checkRange(index);
	}
}


/*
* This function saves the last selected prompt, usually used on 
* onmousedown or onkeydown events
*/
function setLastSelectedPrompt(){
	lastSelectedPrompt = document.getElementById("SelectPrompt").selectedIndex;
}

//--------------------------------------- TimeFormate--------------------------------------------------
/*
* This function seperates the string from the hidden date/time/datetime field 
*/
function parseFromTime(counter, rangemodifier){ 
	try{
		var formatedString = document.getElementById('DateTime'+rangemodifier+counter);
		var tempDate = document.getElementById('Date'+rangemodifier+counter);
		var tempTime = document.getElementById('Time'+rangemodifier+counter);
 		tempDate.value = ''; 
 		tempTime.value = ''; 
 		
 		var teile = formatedString.value.split(','); 
 		for (var i=0; i<teile.length; i++){ 
 			teile[i] = makeNumbers(teile[i]); 
		} 
		if (teile.length == 3){ 
   			if (teile[0].length == 4){
       			for (var i=0; i<3; i++){
           			tempDate.value += teile[i]  
           			if (i != 2){ 
						tempDate.value += '.';
           			} 
      			} 
  			}
  			if (teile[0].length == 2){
      			for (var i=0; i<3; i++){
          			tempTime.value += teile[i]
          			if (i != 2){ 
              			tempTime.value += ':'; 
          			}  
      			}    
  			}
		} 
		if (teile.length == 6){ 
			for (var i=0; i < 3; i++){ 
				tempDate.value += teile[i] 
				if (i != 2){
					tempDate.value += '.';
				} 
			} 
			for (var i=3; i < 6; i++){ 
				tempTime.value += teile[i] 
				if (i != 5){ 
					tempTime.value += ':'; 
				} 
			} 
		} 
	} 
	catch (e){
	}
}

/*
*Creates the Parameter for the hidden date/time/datetime field
*/
function parseToTimeOld(counter, rangemodifier){
	var unformatedStringDate = document.getElementById('Date'+rangemodifier+counter);
	var unformatedStringTime = document.getElementById('Time'+rangemodifier+counter);     
	
    if (unformatedStringTime.value.length == 0 && unformatedStringDate.value.length == 10){ // for Date
    	var date = unformatedStringDate.value.split('.'); 
        for (var i=0; i<date.length; i++){ 
        	date[i] = makeNumbers(date[i]); 
        } 
        var formatedString = 'Date(' + date[0] + ',' + date[1] + ',' + date[2] + ')'; 
        var temp = document.getElementById('DateTime'+rangemodifier+counter);
        temp.value = formatedString; 
	}
    if (unformatedStringTime.value.length == 8 && unformatedStringDate.value.length == 0){ // for Time
        var time = unformatedStringTime.value.split(':'); 
        for (var i=0; i<time.length; i++){ 
            time[i] = makeNumbers(time[i]); 
        } 
        var formatedString = 'Time(' + time[0] + ',' + time[1] + ',' + time[2] + ')'; 
        var temp = document.getElementById('DateTime'+rangemodifier+counter);
        temp.value = formatedString; 
    }
    if (unformatedStringTime.value.length == 8 && unformatedStringDate.value.length == 10){ 
        var time = unformatedStringTime.value.split(':'); 
        var date = unformatedStringDate.value.split('.'); 
        for (var i=0; i<time.length; i++){ 
            time[i] = makeNumbers(time[i]); 
        } 
        for (var i=0; i<date.length; i++){ 
            date[i] = makeNumbers(date[i]); 
        } 
        var formatedString = 'DateTime(' + date[0] + ',' + date[1] + ',' + date[2] + ',' + time[0] + ',' + time[1] + ',' + time[2] + ')'; 
        var temp = document.getElementById('DateTime'+rangemodifier+counter); 
        temp.value = formatedString; 
    } 
} 

/*
*Creates the Parameter for the hidden date/time/datetime field
*/
function parseToTime(counter, rangemodifier){
	var unformatedStringDate = document.getElementById('Date'+rangemodifier+counter);
	var unformatedStringTime = document.getElementById('Time'+rangemodifier+counter);     
	var oDateTime = new DateTime();

        var time = unformatedStringTime.value.split(':'); 
        var date = unformatedStringDate.value.split('.'); 
        for (var i=0; i<time.length; i++){ 
            time[i] = makeNumbers(time[i]);
            if(time[i].length == 0){
            	time[i] = 0;
            } 
        } 
        for (var i=0; i<date.length; i++){ 
            date[i] = makeNumbers(date[i]); 
            if(date[i].length == 0){
            	date[i] = 0;
            } 
        } 
        if (date.length == 3 && time.length != 3){
        	oDateTime.setDateTime(date[0],date[1],date[2],'0','0','0');
        	document.getElementById('DateTime'+rangemodifier+counter).value = oDateTime.getDateFormular();
        }
        if (date.length != 3 && time.length == 3){
        	oDateTime.setDateTime('0','0','0',time[0],time[1],time[2]);
        	document.getElementById('DateTime'+rangemodifier+counter).value = oDateTime.getTimeFormular();
        }
        if (date.length == 3 && time.length == 3){
        	oDateTime.setDateTime(date[0],date[1],date[2],time[0],time[1],time[2]);
        	document.getElementById('DateTime'+rangemodifier+counter).value = oDateTime.getDateTimeFormular();
        }
} 

/*
* This function creates a valid statement for the JS-Calendar 
*/
function parseToCalendar(counter, rangemodifier){
	var formatedString = document.getElementById('DateTime'+rangemodifier+counter);
	var teile = formatedString.value.split(','); 
 	var outString = '';
 	for (var i=0; i<teile.length; i++){ 
 		outString += makeNumbers(teile[i]);
 		if (i<teile.length-1){
 			outString += ','
 		}
		 
	}
	formatedString.value = outString;
}

//--------------------------------------- TimeFormate END----------------------------------------------
//--------------------------------------- Discrete-----------------------------------------------------

/*
* This function checking the Discret Value
*/
function checkDiscrete(i){
	var temp = 'discrete' + i;
    switch(prompts[i].valueType){
		case '6': //Zahl
			alerts += CheckNumber(document.getElementById(temp).value);	
            alerts += checkBorderNumber(document.getElementById(temp).value,i);
  			break;    
		case '7'://Währung
		  	alerts += CheckNumber(document.getElementById(temp).value);
           	alerts += checkBorderNumber(document.getElementById(temp).value,i);
  			break;
  		case '8'://Logisch
  			break;    
		case '9'://Datum
			alerts += CheckTime(document.getElementById('Date'+temp).value);
           	alerts += checkBorderDate(document.getElementById('DateTime'+temp).value,i);
  			break;
  		case '10'://Zeit
        	alerts += CheckTime(document.getElementById('Time'+temp).value);
           	alerts += checkBorderDate(document.getElementById('DateTime'+temp).value,i);
  			break;    
		case '11'://String
          	alerts += checkBorderLength(document.getElementById(temp).value,i);
  			break;
  		case '14':
  			break;    
		case '15'://Datum / Zeit
			alerts += CheckTime(document.getElementById('Date'+temp).value);
        	alerts += CheckTime(document.getElementById('Time'+temp).value);
           	alerts += checkBorderDate(document.getElementById('DateTime'+temp).value,i);
  			break;
		default:
			break;
	}
}
//--------------------------------------- Discrete END-------------------------------------------------
//--------------------------------------- Range -------------------------------------------------------

/*
* This function checking the range Value
*/
function checkRange(i){
	var tempFrom = 'from' + i;
   	var tempTo = 'to' + i;
   	switch(prompts[i].valueType){
		case '6': //Zahl
			alerts += CheckNumber(document.getElementById(tempFrom).value);
			alerts += CheckNumber(document.getElementById(tempTo).value);
			alerts += checkForHighValueNumber(document.getElementById(tempFrom).value,document.getElementById(tempTo).value);
      	   	alerts += checkBorderNumber(document.getElementById(tempTo).value,i);
			break;    
		case '7'://Währung
		  	alerts += CheckNumber(document.getElementById(tempFrom).value);
			alerts += CheckNumber(document.getElementById(tempTo).value);
			alerts += checkForHighValueNumber(document.getElementById(tempFrom).value,document.getElementById(tempTo).value);
           	alerts += checkBorderNumber(document.getElementById(tempTo).value,i);
			break;
		case '8'://Logisch
			break;    
		case '9'://Datum
			alerts += CheckTime(document.getElementById('Date'+tempFrom).value);
			alerts += CheckTime(document.getElementById('Date'+tempTo).value);
			alerts += checkForHighValueDate(document.getElementById('DateTime'+tempFrom).value,document.getElementById('DateTime'+tempTo).value,i);
           	alerts += checkBorderDate(document.getElementById('DateTime'+tempTo).value,i);
			break;
		case '10'://Zeit
			alerts += CheckTime(document.getElementById('Time'+tempFrom).value);
			alerts += CheckTime(document.getElementById('Time'+tempTo).value);
  			alerts += checkForHighValueDate(document.getElementById('DateTime'+tempFrom).value,document.getElementById('DateTime'+tempTo).value,i);
           	alerts += checkBorderDate(document.getElementById('DateTime'+tempTo).value,i);
  			break;    
		case '11'://Zeichenkette
            alerts += checkBorderLength(document.getElementById(tempTo).value,i);
  			break;
  		case '14':
  			break;    
		case '15'://Datum / Zeit
			alerts += CheckTime(document.getElementById('Time'+tempFrom).value);
			alerts += CheckTime(document.getElementById('Time'+tempTo).value);
			alerts += CheckTime(document.getElementById('Date'+tempFrom).value);
			alerts += CheckTime(document.getElementById('Date'+tempTo).value);
  			alerts += checkForHighValueDate(document.getElementById('DateTime'+tempFrom).value,document.getElementById('DateTime'+tempTo).value,i);       	
           	alerts += checkBorderDate(document.getElementById('DateTime'+tempTo).value,i);
  			break;
		default:
			break;
	}
}

/*
* This function creates two statements from one,
* splited by "to"  
*/
function parseFromRange(counter, rangemodifier ){
	var formatedString = document.getElementById('range'+counter);
	var elements = formatedString.value.split('to');
	if (elements.length == 1){
		if(prompts[counter].valueType == 15 || prompts[counter].valueType == 9 || prompts[counter].valueType == 10){
			if(prompts[counter].valueType == 9){
				document.getElementById('DateTimefrom'+counter).value = 'Date(' + makeNumbersUnderline(elements[0])[0] + ')';
			}
			if(prompts[counter].valueType == 10){
				document.getElementById('DateTimefrom'+counter).value = 'Time(' + makeNumbersUnderline(elements[0])[0] + ')';
			}
			if(prompts[counter].valueType == 15){
				document.getElementById('DateTimefrom'+counter).value = 'DateTime(' + makeNumbersUnderline(elements[0])[0] + ')';
			}			
		} else {
			document.getElementById('from'+counter).value = elements[0] ;
		}	
		if(prompts[counter].valueType == 15 || prompts[counter].valueType == 9 || prompts[counter].valueType == 10){
			if(prompts[counter].valueType == 9){
				document.getElementById('DateTimeto'+counter).value = 'Date(' + makeNumbersUnderline(elements[0])[0] + ')';
			}
			if(prompts[counter].valueType == 10){
				document.getElementById('DateTimeto'+counter).value = 'Time(' + makeNumbersUnderline(elements[0])[0] + ')';
			}
			if(prompts[counter].valueType == 15){
				document.getElementById('DateTimeto'+counter).value = 'DateTime(' + makeNumbersUnderline(elements[0])[0] + ')';
			}		
		} else {
			document.getElementById('to'+counter).value = elements[0] ;
		}	
	} 
	if (elements.length == 2){
		var checkbox = new Array();
		var DateTime = new Array();
		for (var i=0; i<elements.length; i++){
			var temp = makeNumbersUnderline(elements[i]);
			DateTime[i] = temp[0];
			checkbox[i] = temp[1];
		}
		if(prompts[counter].valueType == 15 || prompts[counter].valueType == 9 || prompts[counter].valueType == 10){
			if(prompts[counter].valueType == 9){
				document.getElementById('DateTimefrom'+counter).value = 'Date(' + DateTime[0] + ')';
			}
			if(prompts[counter].valueType == 10){
				document.getElementById('DateTimefrom'+counter).value = 'Time(' + DateTime[0] + ')';
			}
			if(prompts[counter].valueType == 15){
				document.getElementById('DateTimefrom'+counter).value = 'DateTime(' + DateTime[0] + ')';
			}		
		} else {
			document.getElementById('from'+counter).value = elements[0];
		}	
        document.getElementById('chfrom'+counter).checked = checkbox[0];
        
		if(prompts[counter].valueType == 15 || prompts[counter].valueType == 9 || prompts[counter].valueType == 10){
			if(prompts[counter].valueType == 9){
				document.getElementById('DateTimeto'+counter).value = 'Date(' + DateTime[1] + ')';
			}
			if(prompts[counter].valueType == 10){
				document.getElementById('DateTimeto'+counter).value = 'Time(' + DateTime[1] + ')';
			}
			if(prompts[counter].valueType == 15){
				document.getElementById('DateTimeto'+counter).value = 'DateTime(' + DateTime[1] + ')';
			}	
		} else {
			var temp2 = document.getElementById('to'+counter).value = elements[1];
		}	
	    document.getElementById('chto'+counter).checked = checkbox[1];
	}
}

/*
* This function creates one statement from two,
* splited by "to"  
*/
function parseToRange(counter, rangemodifier ){
	var chFrom = document.getElementById('chfrom'+counter);
	var chTo = document.getElementById('chto'+counter);
	var From;
	var To;	
	if(prompts[counter].valueType == 15 || prompts[counter].valueType == 9 || prompts[counter].valueType == 10){
		From = document.getElementById('DateTimefrom'+counter);
		To = document.getElementById('DateTimeto'+counter);		
	} else {
		From = document.getElementById('from'+counter);
		To = document.getElementById('to'+counter);
	}
	var Range = document.getElementById('range'+counter);
	Range.value = From.value;
	Range.value += ' ';
	if (chFrom.checked == false){
		Range.value += '_';
	}
	Range.value += 'to';
	if (chTo.checked == false){
		Range.value += '_';
	}
	Range.value += ' ';
	Range.value += To.value;
}
//--------------------------------------- Range END----------------------------------------------------

/*
*Replaces comma with points.
*/
function commaToPoint(Wert){ 
	var temp = ''; 
	for (var i = 0 ; i < Wert.length ; i++){ 
		if ( (Wert.charAt(i) == ',') ){ 
			temp += "."; 
		} else { 
			temp += Wert.charAt(i); 
		} 
	} 
	if (temp.length == 1){ 
		temp = '0' + temp; 
	}
	return temp; 
} 

/*
*Cut all non-number characters from a string
*/
function makeNumbers(Wert){ 
	var temp = ''; 
	for (var i = 0 ; i < Wert.length ; i++){ 
		if ( (Wert.charAt(i) < '0' || Wert.charAt(i) > '9' ) ){ 
		} else { 
			temp += Wert.charAt(i); 
		} 
	} 
	if (temp.length == 1){ 
		temp = '0' + temp; 
	}
	return temp; 
} 

/*
*Cut all non-number characters from a string array
*/
function makeNumbersArray(Wert){ 
	var temp = new Array(Wert.length);
	for (var j = 0 ; j < Wert.length ; j++){ 
		temp[j] = '';
		for (var i = 0 ; i < Wert[j].length ; i++){ 
			if ( (Wert[j].charAt(i) < '0' || Wert[j].charAt(i) > '9' ) ){ 
			} else { 
				temp[j] += Wert[j].charAt(i); 
			} 
		} 
		if (temp[j].length == 1){ 
			temp[j] = '0' + temp[j]; 
		}
	}
	return temp; 
} 

/*
* Cut all non-number characters from a string
* and checking for underlines
*/
function makeNumbersUnderline(Wert){ 
	var temp = ''; 
	var underLine = true;
	for (var i = 0 ; i < Wert.length ; i++){ 
		if ( (Wert.charAt(i) < '0' || Wert.charAt(i) > '9' ) && Wert.charAt(i) != '.' && Wert.charAt(i) != ','){
			if (Wert.charAt(i) == '_'){
				underLine = false;
			}
		} else { 
			temp += Wert.charAt(i); 
		} 
	}
	var tempreturn = new Array(temp, underLine)
	return tempreturn; 
} 

/*
* This function compares two values
*/
function checkForHighValue(min, max){
	if (min > max){
		return lang_1;
	}
	return '';
}

/*
* This function compares two numbers
*/
function checkForHighValueNumber(min, max){
	min = parseFloat(min);
	max = parseFloat(max);
	if (min > max){
		return lang_1;
	}
	return '';
}

/*
* This function compares two Date/Time values
*/
function checkForHighValueDate(min, max, counter){
	var aMax = makeNumbersArray(max.split(','));
	var aMin = makeNumbersArray(min.split(','));
	
	if (prompts[counter].valueType == '9'){
		var oMin = new DateTime(aMin[0],aMin[1],aMin[2],'0','0','0'); 
		var oMax = new DateTime(aMax[0],aMax[1],aMax[2],'0','0','0');
	}
	if (prompts[counter].valueType == '10'){
		var oMin = new DateTime('0','0','0',aMin[0],aMin[1],aMin[2]); 
		var oMax = new DateTime('0','0','0',aMax[0],aMax[1],aMax[2]);
	}
	if (prompts[counter].valueType == '15'){
		var oMin = new DateTime(aMin[0],aMin[1],aMin[2],aMin[3],aMin[4],aMin[5]); 
		var oMax = new DateTime(aMax[0],aMax[1],aMax[2],aMax[3],aMax[4],aMax[5]);
	}
	if (oMin.getDateObject() > oMax.getDateObject()){
		return lang_1 + " " + prompts[counter].names;
	}
	return '';
}

//--------------------------------------- BorderChecker Start ----------------------------------------------------

/*
* This function compares string length
* @param value Wert aus dem Feld
* @param counter Wert der als Range gespeichert ist 
*/
function checkBorderLength(value, counter){
	var hasLow = false;
	var hasHigh = false;
	var returnMsg = '';
	
	if ( prompts[counter].borderLow != null && prompts[counter].borderLow != 'null' ){
		hasLow = true;
	}
	if ( prompts[counter].borderHigh != null && prompts[counter].borderHigh != 'null' ){
		hasHigh = true;
	}
	
	//nichts zu vergleichen
	if(!hasLow && !hasHigh){
		return returnMsg;
	}
	
	//Fehler wenn Border vorhanden, aber kein Value
	if (value == "" && hasLow || value == "" && hasHigh){
		return "\n" + lang_2 + " " + prompts[counter].names;
	}
	
	value = parseFloat(value.length);
	low   = parseFloat(prompts[counter].borderLow);
	high  = parseFloat(prompts[counter].borderHigh);
		
	if(hasLow){
		if(value < low){
		    returnMsg += "\n" + lang_2 + " " + prompts[counter].names;
		    returnMsg += "\n" + value + " < " + low;
		}
	}
	if(hasHigh){
		if(value > high){
	    	returnMsg += "\n" + lang_3 + " " + prompts[counter].names;
	    	returnMsg += "\n" + value + " > " + high;
		}
	}
	
	return returnMsg;
}

/*
* This function compares numbers
* @param value Wert aus dem Feld
* @param counter Wert der als Range gespeichert ist 
*/
function checkBorderNumber(value, counter){
	var hasLow = false;
	var hasHigh = false;
	var returnMsg = '';
	
	if ( prompts[counter].borderLow != null && prompts[counter].borderLow != 'null' ){
		hasLow = true;
	}
	if ( prompts[counter].borderHigh != null && prompts[counter].borderHigh != 'null' ){
		hasHigh = true;
	}
	
	//nichts zu vergleichen
	if(!hasLow && !hasHigh){
		return returnMsg;
	}
	
	//Fehler wenn Border vorhanden, aber kein Value
	if (value == "" && hasLow || value == "" && hasHigh){
		return "\n" + lang_2 + " " + prompts[counter].names;
	}
	
	value = parseFloat(commaToPoint(value));
	low   = parseFloat(prompts[counter].borderLow);
	high  = parseFloat(prompts[counter].borderHigh);
		
	if(hasLow){
		if(value < low){
		    returnMsg += "\n" + lang_2 + " " + prompts[counter].names;
		    returnMsg += "\n" + value + " < " + low;
		}
	}
	if(hasHigh){
		if(value > high){
	    	returnMsg += "\n" + lang_3 + " " + prompts[counter].names;
	    	returnMsg += "\n" + value + " > " + high;
		}
	}
	
	return returnMsg;
}

/*
* This function compares Date/Time values
* @param value Wert aus dem Feld
* @param counter Wert der als Range gespeichert ist 
*/  
function checkBorderDate(value, counter){
	var hasLow = false;
	var hasHigh = false;
	var returnMsg = '';
	
	if ( prompts[counter].borderLow != null && prompts[counter].borderLow != 'null' ){
		hasLow = true;
	}
	if ( prompts[counter].borderHigh != null && prompts[counter].borderHigh != 'null' ){
		hasHigh = true;
	}
	
	//nichts zu vergleichen
	if(!hasLow && !hasHigh){
		return returnMsg;
	}
	
	if (value == "" && hasLow || value == "" && hasHigh){
		return "\n" + lang_2 + " " + prompts[counter].names;
	}
	
	var oValue = null;
	var oBorderLow = null;
	var oBorderHigh = null;
	
	var aValue      = makeNumbersArray(value.split(','));
	
	if (prompts[counter].valueType == '9'){
		oValue      = new DateTime(aValue[0],aValue[1],aValue[2],'0','0','0'); 
	}
	if (prompts[counter].valueType == '10'){
		oValue       = new DateTime('0','0','0',aValue[0],aValue[1],aValue[2]); 
	}
	if (prompts[counter].valueType == '15'){
		oValue       = new DateTime(aValue[0],aValue[1],aValue[2],aValue[3],aValue[4],aValue[5]); 
	}
	
	if(hasLow){
		var aBorderLow  = makeNumbersArray(prompts[counter].borderLow.split(','));
		if (prompts[counter].valueType == '9'){
			oBorderLow  = new DateTime(aBorderLow[0],aBorderLow[1],aBorderLow[2],'0','0','0');
			if(oValue.getDateObject() < oBorderLow.getDateObject()){
	   	 		returnMsg += "\n" + lang_2 + " " + prompts[counter].names;
	   			returnMsg += "\n" + oValue.getDateString() + " < " + oBorderLow.getDateString();
			}
		}
		if (prompts[counter].valueType == '10'){
			oBorderLow   = new DateTime('0','0','0',aBorderLow[0],aBorderLow[1],aBorderLow[2]);
			if(oValue.getDateObject() < oBorderLow.getDateObject()){
	   	 		returnMsg += "\n" + lang_2 + " " + prompts[counter].names;
	   			returnMsg += "\n" + oValue.getTimeString() + " < " + oBorderLow.getTimeString();
			}
		}
		if (prompts[counter].valueType == '15'){
			oBorderLow  = new DateTime(aBorderLow[0],aBorderLow[1],aBorderLow[2],aBorderLow[3],aBorderLow[4],aBorderLow[5]);
			if(oValue.getDateObject() < oBorderLow.getDateObject()){
	   	 		returnMsg += "\n" + lang_2 + " " + prompts[counter].names;
	   			returnMsg += "\n" + oValue.getDateTimeString() + " < " + oBorderLow.getDateTimeString();
			}
		}
	}
	
	
	if(hasHigh){
		var aBorderHigh = makeNumbersArray(prompts[counter].borderHigh.split(','));
		if (prompts[counter].valueType == '9'){
			oBorderHigh = new DateTime(aBorderHigh[0],aBorderHigh[1],aBorderHigh[2],'0','0','0');
			if(oValue.getDateObject() > oBorderHigh.getDateObject()){
	    		returnMsg += "\n" + lang_3 + " " + prompts[counter].names;
	    		returnMsg += "\n" + oValue.getDateString() + " > " + oBorderHigh.getDateString();
			}
		}
		if (prompts[counter].valueType == '10'){
			oBorderHigh  = new DateTime('0','0','0',aBorderHigh[0],aBorderHigh[1],aBorderHigh[2]);
			if(oValue.getDateObject() > oBorderHigh.getDateObject()){
	    		returnMsg += "\n" + lang_3 + " " + prompts[counter].names;
	    		returnMsg += "\n" + oValue.getTimeString() + " > " + oBorderHigh.getTimeString();
			}
		}
		if (prompts[counter].valueType == '15'){
			oBorderHigh = new DateTime(aBorderHigh[0],aBorderHigh[1],aBorderHigh[2],aBorderHigh[3],aBorderHigh[4],aBorderHigh[5]);	
			if(oValue.getDateObject() > oBorderHigh.getDateObject()){
	    		returnMsg += "\n" + lang_3 + " " + prompts[counter].names;
	    		returnMsg += "\n" + oValue.getDateTimeString() + " > " + oBorderHigh.getDateTimeString();
			}
		}	
	}
	return returnMsg;
}

//--------------------------------------- BorderChecker End ----------------------------------------------------

/*
* This function checking a string for time / datetime
*/
function CheckTime(Wert){
    var rexTime     =  "\d{1,2}\s*:\s*\d{1,2}\s*:\s*\d{1,2}\s*";
    var rexDate     =  "date\s*\(\s*\d{1,4}\s*,\s*\d{1,2}\s*,\s*\d{1,2}\s*\)";
    var rexDateTime =  "time\s*\(\s*\d{1,4}\s*,\s*\d{1,2}\s*,\s*\d{1,2}\s*,\s*\d{1,2}\s*,\s*\d{1,2}\s*,\s*\d{1,2}\s*\)";


	var resultTime     = Wert.match(rexTime);
	var resultDate     = Wert.match(rexDate);
	var resultDateTime = Wert.match(rexDateTime);

	if(resultTime){
	for (var i = 0; i < resultTime.length; ++i) {
    	alert("TestT: Fund " + i + " - " + resultTime[i]);
    }
    }
    if(resultDate){
    for (var i = 0; i < resultDate.length; ++i) {
    	alert("TestD: Fund " + i + " - " + resultDate[i]);
    }
    }
    if(resultDateTime){
    for (var i = 0; i < resultDateTime.length; ++i) {
    	alert("TestDT: Fund " + i + " - " + resultDateTime[i]);
    }
    }


/*
*    var chkZ = 0;
*    for (var i = 0 ; i < Wert.length ; i++){
*        if ( (Wert.charAt(i) < '0' || Wert.charAt(i) > '9' ) && Wert.charAt(i)!='.' && Wert.charAt(i)!=':' && Wert.charAt(i)!=' '){
*           chkZ = -1;
*       }
*   }
*   if (chkZ == -1) {
*       return lang_4 + " " + Wert;
*   }
*/   
	return '';
}

/*
* This function checking a string for numbers / date / money
*/
function CheckNumber(Wert){
	var chkZ = 0;
	for (var i = 0 ; i < Wert.length ; i++){
		if ( (Wert.charAt(i) < '0' || Wert.charAt(i) > '9' ) && Wert.charAt(i)!='.' && Wert.charAt(i)!=',' && Wert.charAt(i)!='-'){
           	chkZ = -1;
    	}
    }
    if (chkZ == -1) {
    	
    	return lang_4 + " " + Wert;
   	}
	return '';
}

/*
* This function checking a string for letters
*/
function CheckLetter(Wert){
    var chkB = 0;
    for (i = 0; i < Wert.length; i++){
        var ch = Wert.substring(i, i + 1);
        if (((ch < 'a' || 'z' < ch) && (ch < 'A' || 'Z' < ch)) && ch!=' ') {
            chkB = 1;
        }
    }
    if (chkB == 1) {
        return lang_5 + Wert;
    }
  	return '';
}

/*
* This function sets the table visible and hidden
*/
function setTable(){
	var idSelected = document.getElementById("SelectPrompt").selectedIndex;	
	for (var i=0 ; i < prompts.length ; i++)
	{   
		var table = document.getElementById('DivTable'+i)
		if (i != idSelected) {
    		table.style.visibility = 'hidden'; 
    		table.style.position = 'relative';
            table.style.display = 'none'; 
    	}
    	else {
    	 	table.style.visibility = 'visible'; 
    	 	table.style.position = 'relative';
            table.style.display = 'block'; 
    	}
    }
}

/*
* This function adding an element to the select box.
*/
function addElement(counter, modifier){
	var divContent = document.getElementById('DivSelect'+counter);
	if((prompts[counter].valueType == 15 || prompts[counter].valueType == 10 || prompts[counter].valueType == 9) && modifier != 'range' ){
		if (modifier == 'selrange'|| modifier == 'seldiscrete'){
			var newContent = document.getElementById(modifier+counter).options[document.getElementById(modifier+counter).selectedIndex];
		} else {
			var newContent = document.getElementById('DateTime'+modifier+counter);
		}
	} else {
		if (modifier == 'selrange'|| modifier == 'seldiscrete'){
			var newContent = document.getElementById(modifier+counter).options[document.getElementById(modifier+counter).selectedIndex];
		} else {
			var newContent = document.getElementById(modifier+counter);
		}
	}
	var oldContent = document.getElementById('multi'+counter);
	
	if (oldContent.value.length > 0){
		oldContent.value += '|' + newContent.value;
	} else {
		oldContent.value += newContent.value;

	}
	var textElements = parseText(oldContent.value);		
	var tempContent = "<select size=\"5\" name=\"Zahlen Range+Multi\" id=\"selmulti"+counter+"\" class=\"MultiSel\">";
	for (var i=0; i < textElements.length; i++){
		tempContent += "<option value=\"" + textElements[i] + "\">";
		tempContent += textElements[i]
		tempContent += "</option>";
	}
	tempContent += "</select>";
	divContent.innerHTML = tempContent;
}

/*
* This function removes the selected element from the select box.
*/
function removeElement(counter){
	var divContent = document.getElementById('DivSelect'+counter);
	var idSelected = document.getElementById('selmulti'+counter).selectedIndex;
	var oldContent = document.getElementById('multi'+counter);
	var textElements = parseText(oldContent.value);
	var prevSelected = 0;
	oldContent.value = '';
	for(var i = 0; i < textElements.length; i++ ){		
		if (i != idSelected){
			oldContent.value += textElements[i];
			if ( i < textElements.length-1 && textElements.length > 1 && textElements[i].length > 0){
				oldContent.value += '|';
			}
		} else {
			prevSelected = i;
		}
	}
	textElements = parseText(oldContent.value);
	var tempContent = "<select size=\"5\" name=\"Zahlen Range+Multi\" id=\"selmulti"+counter+"\" class=\"MultiSel\">";
	for (var i=0; i < textElements .length; i++){
		if ( i != prevSelected ) {
			tempContent += "<option value=\"" + textElements [i] + "\">" + textElements [i] + "</option>";
		} else {
			tempContent += "<option value=\"" + textElements [i] + "\" selected>" + textElements [i] + "</option>";
		}
	}
	tempContent += "</select>";
	divContent.innerHTML = tempContent;
}

/*
* This function splits a string with a "|".
*/
function parseText(text){
	textArray = text.split('|');
	return textArray;
}

/*
* This function updates all range values.
*/
function updateAllRange(){
	for(var i=0; i < prompts.length; i++){
		if(prompts[i].range == "true"){
			parseToRange(i,'range');
		}
	}
}

/*
* This function transforms the string, splitted by a "|" in to 
* the formula notation.
*/
function multiToPrompt(){
	for(var j=0; j < prompts.length; j++){
		if(prompts[j].multi == true){
			var tempObject = document.getElementById('multi'+j);
			var tempArray = tempObject.value.split('|');
			if(prompts[j].valueType != 11){
				var tempArrayOut = '[';
			} else {
				var tempArrayOut = '[\'';
			} 
			for (var i=0; i < tempArray.length; i++ ){
				tempArrayOut += tempArray[i];
				if(i < tempArray.length-1){
					if(prompts[j].valueType != 11){
						tempArrayOut += ',';
					} else {
						tempArrayOut += '\',\'';
					} 				
				}
			}
			if(prompts[j].valueType != 11){
				tempArrayOut += ']';
			} else {
				tempArrayOut += '\']';
			} 
			tempObject.value = tempArrayOut;
		}
	}
}

function end(cal) {
	for (var i=0; i < prompts.length; i++){
		if (prompts[i].discrete == true){
			parseFromTime(i,'discrete');
		}
		if (prompts[i].range == true){
			parseFromTime(i,'from');
			parseFromTime(i,'to');
			parseToRange(i, 'range' );
		}	
	}	
}

/*
* This function loading the languagefiles for the calendar based on the
* "locale" property, if this not available, it used the browser locale
* if this also not available, it used default english  
*/
var languages = new Array("af","al","bg","big5","br","ca","da","de","du","el","en","es","fi","fr","hr","hu","it","jp","ko","lt","lv","nl","no","pl","pt","ro","ru","si","sk","sp","sv","tr","zh");
var languages_utf8 = new Array("big5","cn","cs","he","hr","ko","lt","pl");

function start(lang){
	var foundLang = false;
	if( document.createElement ){				
		var scriptElement = document.createElement( "script" );	
		
		for (var j=0; j<languages.length;j++){
			if(languages[j] == lang){
				scriptElement.setAttribute( "src", PFAD + "calendar/lang/calendar-" + lang + ".js" );
				foundLang = true;
			}
		} 
		for (var j=0; j<languages_utf8.length;j++){
			if(languages_utf8[j] == lang){
				scriptElement.setAttribute( "src", PFAD + "calendar/lang/calendar-" + lang + "-utf8.js" );
				foundLang = true;
			}
		} 
		
		if(!foundLang){
			browsername = navigator.appName;
			switch(browsername) {
				case "Microsoft Internet Explorer":
					lang = navigator.userLanguage;
					break;
				case "Netscape":
					lang = navigator.language;
					break;
				case "Opera":
					lang = navigator.userLanguage;
					break;
				default:
					if(navigator.userLanguage){
						lang = navigator.userLanguage;
					} else {
						lang = navigator.language;
					}
					break;
			}
		}		
		for (var j=0; j<languages.length;j++){
			if(languages[j] == lang){
				scriptElement.setAttribute( "src", PFAD + "calendar/lang/calendar-" + lang + ".js" );
				foundLang = true;
			}
		} 
		for (var j=0; j<languages_utf8.length;j++){
			if(languages_utf8[j] == lang){
				scriptElement.setAttribute( "src", PFAD + "calendar/lang/calendar-" + lang + "-utf8.js" );
				foundLang = true;
			}
		} 
		if(!foundLang){
			scriptElement.setAttribute( "src", PFAD + "calendar/lang/calendar-en.js" );
		}
		document.body.appendChild( scriptElement );
	}
}

/*
*This functions are nessesary for the editable dropdown list
*/
var fActiveMenu = false;
var oOverMenu = false;

function mouseSelect(e){
	if (fActiveMenu){
		if (oOverMenu == false) {
			document.getElementById(fActiveMenu).style.display = "none";
			fActiveMenu = false;
			return false;
		}
		return false;
	}
	return true;
}

/*
* idEdit - Textfield
* idMenu - Div
* idSel  - Select
* idImg	 - Image
*/
function menuActivate(idEdit, idMenu, idSel, idImg){
	if (fActiveMenu) return mouseSelect(0);

	oMenu = document.getElementById(idMenu);
	oEdit = document.getElementById(idEdit);
	oImg  = document.getElementById(idImg);
	n1Top = oEdit.offsetTop + oEdit.offsetHeight;
	n1Left = oEdit.offsetLeft;
	nTop = 0;
	nLeft = 0;
	
	if( oImg.x || oImg.y ){
		nTop = oImg.y;
		nLeft = oImg.x;
	} else {
		while (oImg.offsetParent != document.body){
			nTop += oImg.offsetTop;
			nLeft += oImg.offsetLeft;
			oImg = oImg.offsetParent;

		}	
	}
	oMenu.style.left = nLeft-358;
	oMenu.style.top = nTop+25;
	oMenu.style.display = "";
	fActiveMenu = idMenu;
	return false;
}

function textSet(idEdit, text)
{
	document.getElementById(idEdit).value = text;
	oOverMenu = false;
	mouseSelect(0);
}

function comboKey(idEdit, idSel)
{
	if (window.event.keyCode == 13 || window.event.keyCode == 32)
		textSet(idEdit,idSel.value);
	else if (window.event.keyCode == 27)
	{
		mouseSelect(0);
	}
}
document.onmousedown = mouseSelect;

//------------------------------------OBJEKTE-------------------------------------------------------------

// Objekt und Methoden für DATETIME
// Benutzt für alle Date/Time/DateTime Felder

function DateTime(){
	this.year 	= '0';
	this.month	= '0';
	this.day	= '0';
	this.hour	= '0';
	this.minute	= '0';
	this.second	= '0';
	this.description = '';
	this.date = new Date(this.year, this.month-1, this.day, this.hour, this.minute, this.second);
}

function DateTime(year,month,day,hour,minute,second,description){
	this.year 	= year;
	this.month	= month;
	this.day	= day;
	this.hour	= hour;
	this.minute	= minute;
	this.second	= second;
	this.description = description;
	this.date = new Date(this.year, this.month-1, this.day, this.hour, this.minute, this.second);
}

DateTime.prototype.getDateFormular = function(){
	var temp = "Date(" + this.date.getFullYear() + "," + (this.date.getMonth()+1) + ","	+ this.date.getDate() + ")";
	return temp;
}

DateTime.prototype.getDateString = function(){
	var temp = this.date.getFullYear() + "." + (this.date.getMonth()+1) + "." + this.date.getDate();
	return temp;
}
DateTime.prototype.getTimeFormular = function(){
	var temp = "Time(" + this.date.getHours() + "," + this.date.getMinutes() + "," + this.date.getSeconds()+ ")";
	return temp;
}
DateTime.prototype.getTimeString = function(){
	var temp = this.date.getHours() + ":" + this.date.getMinutes() + ":" + this.date.getSeconds();
	return temp;
}
DateTime.prototype.getDateTimeFormular = function(){
	var temp = "DateTime(" + this.date.getFullYear() + "," + (this.date.getMonth()+1) + ","	+ this.date.getDate() + "," + this.date.getHours() + "," + this.date.getMinutes() + "," + this.date.getSeconds()+ ")";
	return temp;
}
DateTime.prototype.getDateTimeString = function(){
	var temp = this.date.getFullYear() + "." + (this.date.getMonth()+1) + "."	+ this.date.getDate() + " " + this.date.getHours() + ":" + this.date.getMinutes() + ":" + this.date.getSeconds();
	return temp;
}
DateTime.prototype.getDesc = function(){
	var temp = this.description;
	return temp;
}

DateTime.prototype.getDateObject = function(){
	var temp = this.date;
	return temp;
}

DateTime.prototype.getDateMilliseconds = function(){
	var temp = this.date.getMilliseconds();
	return temp;
}

DateTime.prototype.setDateTime = function(year,month,day,hour,minute,second){
	this.year 	= year;
	this.month	= month;
	this.day	= day;
	this.hour	= hour;
	this.minute	= minute;
	this.second	= second;
	this.date = new Date(this.year, this.month-1, this.day, this.hour, this.minute, this.second);
}

DateTime.prototype.checkDateTime = function(){
	if (this.date){
		return true;
	} else {
		return false;
	}
}