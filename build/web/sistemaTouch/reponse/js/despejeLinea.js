var despejeLinea=new function()
{
    this.panelRegistroDespeje,this.divRegistroDespejeDespeje,this.admin=false,
    this.codProgramaProd,this.codLote,this.codHoja,this.codPersonalApruebaDespeje,this.codPersonalUsuario;
    this.verificarDespejeLinea=function(codPersonalApruebaDespeje,admin,codProgramaProd,codLote,codHoja,codPersonalUsuario)
    {
        this.codPersonalUsuario=codPersonalUsuario;
        this.codPersonalApruebaDespeje=codPersonalApruebaDespeje;
        this.codProgramaProd=document.getElementById(codProgramaProd).value;
        this.codLote=document.getElementById(codLote).value;
        this.codHoja=codHoja;
        this.admin=admin;
        if(this.codPersonalApruebaDespeje==0)
        {
            this.crearLogin();
            this.mostrarLogin();

        }

    }
    this.mostrarLogin=function()
    {
        this.divRegistroDespeje.className='panelRegistroVisible';
        this.panelRegistroDespeje.className='panelModalVisible';
    }
    this.aprobarDespejeLinea=function()
    {
        var ajax=nuevoAjax();
        var peticion=(this.codHoja==5?"":"../")+"ajaxAprobarDespejeLineaLote.jsf?codLote="+this.codLote+"&codProgramaProd="+this.codProgramaProd+
            "&codHoja="+this.codHoja+"&codPersonalUsuario="+this.codPersonalUsuario+
            "&data="+(new Date()).getTime().toString();
        ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se aprobo el despeje de linea');
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                    }
                }

                ajax.send(null);
    }
    
    this.crearLogin=function()
    {
         this.panelRegistroDespeje=document.createElement("div");
         this.panelRegistroDespeje.className='panelModalHide';
         this.panelRegistroDespeje.id='panelRegistroDespejeDespeje';
         this.divRegistroDespeje=document.createElement("div");
         this.divRegistroDespeje.className='panelModalHide';
         this.divRegistroDespeje.id='divLogin';
         var tabla="<center>"+
                            " <table   class='tablaRegistro' style='border-color:#a80077;background-color:white;' cellpadding='0' cellspacing='0'>"+
                               "<tr><td class='celdaCabeceraTime' colspan='3' ><span style='width:1.5em'>Despeje de Linea</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' style='padding:0.7em;font-size:1em' >Realizar segun POE PRO-LES-IN-017 \"DESPEJE DE LINEA DE TRABAJO\"<br><br>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo."+
                               "<br><br><span style='font-weight:bold'>Aprobado por:</span>Sin Aprobacion</td></tr>"+
                               "<tr><td bgColor='white' style='border-radius: 15px;' align='center' colspan='3'>"+(this.admin?"<button  class='buttonHIde'    style='width:40%;' onclick='despejeLinea.aprobarDespejeLinea();' >Aprobar</button>":"")+
                               "<button  class='buttonHIde'  style='border-radius: 15px;width:40%;' onclick='window.close()' >Cancelar</button></td>"+
                               "</tr>"+
                               "</table><center>";
         this.divRegistroDespeje.innerHTML=tabla;



         document.body.appendChild(this.divRegistroDespeje);
         document.body.appendChild(this.panelRegistroDespeje);
    }
}