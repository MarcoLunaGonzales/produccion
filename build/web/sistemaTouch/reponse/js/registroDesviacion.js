function registroDesviacion()
{
    this.panelRegistroDespeje,this.divRegistroDespejeDespeje,this.admin=false,
    this.iniciarRegistroDesviacion=function()
    {
         this.divRegistroDespeje.className='panelRegistroVisible';
        this.panelRegistroDespeje.className='panelModalVisible';
    }
    this.crearRegistroDesviacion=function()
   {
       var  buttonRegistro=document.createElement("div");
        buttonRegistro.className='small button succes radius buttonDesviacion';
        buttonRegistro.innerHTML="Desv.";
        buttonRegistro.onclick=function(){registroDesviacion.iniciarRegistroDesviacion();};
        document.body.appendChild(buttonRegistro);
        this.panelRegistroDespeje=document.createElement("div");
         this.panelRegistroDespeje.className='panelModalHide';
         this.panelRegistroDespeje.id='panelRegistroDesviacion';
         this.divRegistroDespeje=document.createElement("div");
         this.divRegistroDespeje.className='panelModalHide';
         this.divRegistroDespeje.id='divRegistroDesviacion';
         var tabla="<center>"+
                            " <table   class='tablaRegistro' style='border-color:#a80077;background-color:white;' cellpadding='0' cellspacing='0'>"+
                               "<tr><td class='celdaCabeceraTime' style='border-bottom-right-radius:0px;border-bottom-left-radius:0px;' colspan='3' ><span style='width:1.5em'>REGISTRO DE DESVIACIONES</span></td></tr>"+
                               "<tr><td bgcolor='white' style='border: 1px solid #a80077;border-bottom-left-radius:10px;border-bottom-right-radius:10px;' colspan='3' ><span style='width:1.5em'>"+
                               "<b>Fecha de Deteccion:"+fechaSistemaGeneral+"</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' style='padding:0.7em;' >"+
                               "<table style='border-color:#a80077;background-color:white;' cellpadding='0' cellspacing='0'>"+
                               "<tr><td align='center'>Desviacion Planificada<br><input type='checkbox'/></td>"+
                               "<td align='center'>Desviacion<br><input type='checkbox'/></td>"+
                               "<td align='center'>Observacion<br><input type='checkbox'/></td></tr>"+
                               "<tr><td align='center' colspan='3'><b>Descripcion de la desviacion</b><br>"+
                               "<textArea style='width:100%'></textArea></td>"+
                               "</table>"+
                               "</td></tr>"+
                               "<tr><td bgColor='white' style='border-radius: 15px;' align='center' colspan='3'>"+(this.admin?"<button  class='buttonHIde'    style='width:40%;' onclick='despejeLinea.aprobarDespejeLinea();' >Aprobar</button>":"")+
                               "<button  class='buttonHIde'  style='border-radius: 15px;width:40%;' onclick='window.close()' >Cancelar</button></td>"+
                               "</tr>"+
                               "</table><center>";
         this.divRegistroDespeje.innerHTML=tabla;
         document.body.appendChild(this.divRegistroDespeje);
         document.body.appendChild(this.panelRegistroDespeje);
    }
}
var registroDesviacion=new registroDesviacion();
registroDesviacion.crearRegistroDesviacion();
