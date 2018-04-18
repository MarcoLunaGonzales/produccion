<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js" ></script> 
    <script>
                function cogerId(obj){
                    alert(obj);
                  
                }
                function getCodigo(codigo,codFormula,nombre,cantidad, codProd,codLoteProd,codTipoProgramaProd){
                  //  alert(codLoteProd);
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&codCompProd='+codProd+'&cod_lote_prod='+codLoteProd+'&codTipoProgramaProd='+codTipoProgramaProd;
                  //alert(url);
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                
                  		
                  location='../reporteExplosionProductosSimulacion/guardarReservaProgramaProd.jsf?codigo='+codigo;


                }

                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    //alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }    
                
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
    function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     function enviar(codProgramaProduccion, codigo, fecha_ini, fecha_fin,conProductosEnProceso){
        var ajax=nuevoAjax();
        var valores='codProgramaProduccion='+codProgramaProduccion+'&codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin+'&conProductosEnProceso='+conProductosEnProceso;
        valores+='&pq='+(Math.random()*1000);        
        var url='../reporteExplosionProductosSimulacion/filtroReporteExplosion.jsf';
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
           /* var p=document.createElement('img');
             p.src='../img/load.gif';
             var div=document.createElement('div');
             div.style.paddingTop='150px';
             div.style.paddingLeft='20px';
             div.style.textAlign='center';
             div.style.top='0px';
             div.style.left='0px';
             div.style.position='absolute';
             div.innerHTML='CARGANDO...';
             div.style.fontFamily='Verdana';
             div.style.fontSize='11px';
             div.style.width='200px';
             div.appendChild(p);
             div.style.filter='alpha(opacity=40)';
             main.appendChild(div);
             
             */
             document.getElementById('contenido').style.visibility='visible';
             document.getElementById('contenido').style.zIndex = 5;
             document.getElementById('contenido').style.backgroundColor="#f2f2f2";
             document.getElementById('botones').style.visibility='hidden';
             //document.getElementById('botones').style.left=0px;
             //document.getElementById('botones').style.top=0px;
             
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        }
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    function seleccionarTodo(){
       //alert('entro');
       var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
       var elements=document.getElementById('form1:dataFormula');

       if(seleccionar_todo.checked==true){  
         //alert('entro por verdad');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=true;
                }
            }
       }
       else
       {//alert('entro por false');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=false;
                }
            }

       }
       return true;

    }
    function trim (myString)
                {
                    return myString.replace(/^\s+/g,'').replace(/\s+$/g,'')
                }

     function seleccionarItem(nametable,producto,lote,check){
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    
                    //se verifica si esta seleccionado
                    //alert(check.checked);

                    if(check.checked==true){
                       for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=true;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }else{
                         for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=false;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }

                   
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function seleccionarProducto(obj){
                       var elements1=document.getElementById("formRegistrar:dataProductos");
                       var rowsElement1=elements1.rows;
                       //alert(rowsElement1.length);

                       //hallamos los valores que corresponden al check codCompProd codTipoProgramaProd
                       var codCompProd = "";
                       var codTipoProgramaProd = "";
                       var cells = obj.parentNode.parentNode.cells;
                       var cell0= cells[0];
                          if(cell0.getElementsByTagName('input').length>0){
                                if(cell0.getElementsByTagName('input')[0].type=='checkbox'){
                                  codCompProd =cells[1].innerHTML;
                                  codTipoProgramaProd =cells[2].innerHTML;
                                }
                            }
                       var cell4= cells[4];
                       if(cell4!=null){
                           if(cell4.getElementsByTagName('input').length>0){
                                if(cell4.getElementsByTagName('input')[0].type=='checkbox'){
                                  codCompProd=cells[5].innerHTML;
                                  codTipoProgramaProd = cells[6].innerHTML;
                                }
                            }
                       }
                       for(var i=1;i<rowsElement1.length;i++){
                            var cellsElement1=rowsElement1[i].cells;
                            var cel0=cellsElement1[0]; //check en posicion 0
                            var cel1 =cellsElement1[1];
                            var cel2 =cellsElement1[2];
                            if(cel0.getElementsByTagName('input').length>0){
                                if(cel0.getElementsByTagName('input')[0].type=='checkbox'){
                                    if(cel1.innerHTML ==codCompProd && cel2.innerHTML ==codTipoProgramaProd){
                                        cel0.getElementsByTagName('input')[0].checked = obj.checked;
                                    }
                                }
                            }
                            
                            var cel4=cellsElement1[4];//el check en la posicion 4
                            var cel5=cellsElement1[5];
                            var cel6=cellsElement1[6];

                            if(cel4!=null && cel4.getElementsByTagName('input').length>0){
                                if(cel4.getElementsByTagName('input')[0].type=='checkbox'){
                                    if(cel5.innerHTML ==codCompProd && cel6.innerHTML ==codTipoProgramaProd){
                                        cel4.getElementsByTagName('input')[0].checked = obj.checked;
                                    }
                                }
                            }
                       }
                        //var fecha1=obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[6].getElementsByTagName('input')[1].value;
                        //var fecha2=obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[7].getElementsByTagName('input')[1].value;
                        //obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
                }
                function seleccionarTodo_1(){
                    //alert('entro');
                    var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
                    var elements=document.getElementById('form1:productosProducir');

                    if(seleccionar_todo.checked==true){
                        //alert('entro por verdad');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=true;
                            }
                        }
                    }
                    else
                    {//alert('entro por false');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=false;
                            }
                        }
                    }
                    return true;
                }
                function seleccionarTodo_2(){
                    //alert('entro');
                    var seleccionar_todo=document.getElementById('form1:seleccionar_todo1');
                    var elements=document.getElementById('form1:dataFormula');

                    if(seleccionar_todo.checked==true){
                        //alert('entro por verdad');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=true;
                            }
                        }
                    }
                    else
                    {//alert('entro por false');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=false;
                            }
                        }
                    }
                    return true;
                }
            </script>
</head>
<body >
    
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >
        
        <h:outputText value="#{ManagedProgramaProduccionSimulacion.cargarProductosAprobacion}"  />
        <h:outputText styleClass="outputTextTitulo"  value="Productos por Aprobar" />
        <br><br>
        <table style="border-color:black">
            <tr>
                <td>
                    <h:selectBooleanCheckbox id="seleccionar_todo1"  onclick="seleccionarTodo_2();"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" />
                </td><td>
                    <h:selectBooleanCheckbox id="seleccionar_todo"  onclick="seleccionarTodo_1();"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Seleccionar Todos" /></td>
            </tr>
            <tr><td>

        <div style="height:350px;overflow:auto">
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.productosProduccionList}"
                        var="data" id="dataFormula"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente_1"
                        >
            
            
            <rich:column>
                <f:facet name="header">
                    <h:outputText value=""  />
                </f:facet>
                <h:selectBooleanCheckbox value="#{data.checked}"  />
            </rich:column>
            <rich:column>
                <f:facet name="header">
                    <h:outputText value="Producto"  />
                </f:facet>
                <h:outputText value="#{data.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
            </rich:column>
              
            <rich:column>
                <f:facet name="header">
                    <h:outputText value="Lote"  />
                </f:facet>
                <h:outputText value="#{data.programaProduccion.formulaMaestra.cantidadLote}"  />
            </rich:column>
           <rich:column style="background-color:aqua">
                <f:facet name="header">
                    <h:outputText value="MC"  />
                </f:facet>
                <h:outputText value="#{data.cantMC}"  />
            </rich:column>
           <rich:column style="background-color:aqua">
                <f:facet name="header">
                    <h:outputText value="MM"  />
                </f:facet>
                <h:outputText value="#{data.cantMM}"  />
            </rich:column>
           <rich:column style="background-color:aqua">
                <f:facet name="header">
                    <h:outputText value="MI"  />
                </f:facet>
                <h:outputText value="#{data.cantMI}"  />
            </rich:column>
            
            <rich:column style="width:20px">
                <f:facet name="header">
                    <h:outputText value="Lotes Prog."  />
                </f:facet>
                <h:outputText value="#{data.lotesProgramados}"  />
            </rich:column>

            <rich:column style="background-color:#{data.colorMP}">
                <f:facet name="header">
                    <h:outputText value="MP"  />
                </f:facet>
                <h:outputText value=""  />
            </rich:column>
            <rich:column style="background-color:#{data.colorEP}">
                <f:facet name="header">
                    <h:outputText value="EP"  />
                </f:facet>
                <h:outputText value=""  />
            </rich:column>
            <rich:column style="background-color:#{data.colorES}">
                <f:facet name="header">
                    <h:outputText value="ES"  />
                </f:facet>
                <h:outputText value=""  />
            </rich:column>
            <rich:column style="background-color:#{data.colorHorasMaquina}">
                <f:facet name="header">
                    <h:outputText value="HM"  />
                </f:facet>
                <h:outputText value=""  />
            </rich:column>
            <rich:column style="width:20px">
                <f:facet name="header">
                    <h:outputText value="Lotes que se pueden fabricar (MP)"  />
                </f:facet>
                <h:panelGrid columns="2" styleClass="outputText2">
                    <h:outputText value="MC:" />
                    <h:outputText value="#{data.lotesFabricarMP_MC}" styleClass="outputText1"  />
                    <h:outputText value="MM:" />
                    <h:outputText value="#{data.lotesFabricarMP_MM}" styleClass="outputText1"   />
                    <h:outputText value="MI:" />
                    <h:outputText value="#{data.lotesFabricarMP_MI}" styleClass="outputText1"  />
                </h:panelGrid>
            </rich:column>
            <rich:column style="width:20px">
                <f:facet name="header">
                    <h:outputText value="Lotes que se pueden fabricar (MP)(EP)"  />
                </f:facet>
                <h:panelGrid columns="2" styleClass="outputText2">
                    <h:outputText value="MC:" />
                    <h:outputText value="#{data.lotesFabricarMPEP_MC}" styleClass="outputText1"   />
                    <h:outputText value="MM:" />
                    <h:outputText value="#{data.lotesFabricarMPEP_MM}" styleClass="outputText1"   />
                    <h:outputText value="MI:" />
                    <h:outputText value="#{data.lotesFabricarMPEP_MI}" styleClass="outputText1"   />
                </h:panelGrid>
            </rich:column>
            <rich:column style="width:20px">
                <f:facet name="header">
                    <h:outputText value="Lotes que se pueden fabricar (MP) (EP) (ES)"  />
                </f:facet>
                <h:panelGrid columns="2" styleClass="outputText2">
                    <h:outputText value="MC:" />
                    <h:outputText value="#{data.lotesFabricarMPEPS_MC}" styleClass="outputText1"   />
                    <h:outputText value="MM:" />
                    <h:outputText value="#{data.lotesFabricarMPEPS_MM}" styleClass="outputText1"   />
                    <h:outputText value="MI:" />
                    <h:outputText value="#{data.lotesFabricarMPEPS_MI}" styleClass="outputText1"   />
                </h:panelGrid>
            </rich:column>
            <rich:column style="width:20px">
                <f:facet name="header">
                    <h:outputText value="Lotes por fabricar"  />
                </f:facet>
                <h:panelGrid columns="2" styleClass="outputText2">
                    <h:outputText value="MC:" />
                    <h:inputText value="#{data.lotesFabricarMC}" styleClass="outputText1"  size="4"  />
                    <h:outputText value="MM:" />
                    <h:inputText value="#{data.lotesFabricarMM}" styleClass="outputText1"  size="4"  />
                    <h:outputText value="MI:" />
                    <h:inputText value="#{data.lotesFabricarMI}" styleClass="outputText1"  size="4"  />
                </h:panelGrid>
            </rich:column>
            
        </rich:dataTable>
        
        </div>
        <a4j:commandButton value="Explosion de Maquinaria" action="#{ManagedProgramaProduccionSimulacion.explosionMaquinaria_1}" styleClass="btn" oncomplete="openPopup('../reportes/explosionMaquinarias/navegadorReporteExplosionMaquinarias_1.jsf')" />

         </td><td>


                          <div style="height:350px;overflow:auto">
                          <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.productosProducirList}"
                                        var="fila" id="productosProducir"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente_1"
                                        >

                            <!--document.getElementById('form:panelMateriales').style.visibility='visible';-->

                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="" />
                                </f:facet>

                                <h:selectBooleanCheckbox value="#{fila.checked}" >
                                                
                                </h:selectBooleanCheckbox>
                            </rich:column>
                            <rich:column style="background-color: #{fila.colorFila}" >
                                            <f:facet name="header">
                                                <h:outputText value=""  />
                                            </f:facet>
                                            <h:outputText value=""  />
                            </rich:column>

                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Producto" />
                                </f:facet>
                                <h:outputText value="#{fila.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                            </rich:column>

                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Cantidad" />
                                </f:facet>
                                <h:outputText value="#{fila.formulaMaestra.cantidadLote}"   />
                            </rich:column>

                            <rich:column  >
                                <f:facet name="header">
                                    <h:outputText value="Lote"  />
                                </f:facet>
                                <h:outputText value="#{fila.codLoteProduccion}"  />
                            </rich:column>

                            <rich:column  >
                                <f:facet name="header">
                                    <h:outputText value="Nro Lotes"  />
                                </f:facet>
                                <h:outputText value="#{fila.nroLotes}"  />
                            </rich:column>

                            <rich:column  >
                                <f:facet name="header">
                                    <h:outputText value="Tipo"  />
                                </f:facet>
                                <h:outputText value="#{fila.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                            </rich:column>
                            <rich:column  >
                                <f:facet name="header">
                                    <h:outputText value="Estado"  />
                                </f:facet>
                                <h:outputText value="#{fila.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                            </rich:column>

                        </rich:dataTable>
                        
                        </div>
                        <a4j:commandButton value="Explosion de Maquinaria" action="#{ManagedProgramaProduccionSimulacion.explosionMaquinarias}" styleClass="btn" oncomplete="openPopup('../reportes/explosionMaquinarias/navegadorReporteExplosionMaquinaria_2.jsf')" />
             



                        
         </td></tr>
        </table>
        <div>
            
            
        </div><br/>
        <div>
        <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedProgramaProduccionSimulacion.seleccionarProductosAprobacion_action}"
        oncomplete="if(#{ManagedProgramaProduccionSimulacion.materialConflicto == '1'}){Richfaces.showModalPanel('PanelMaterialConflicto')}" reRender="dataFormula,productosProducir,contenidoMaterialConflicto" />        
        <a4j:commandButton value="Procesar Materiales" styleClass="btn"
                            action="#{ManagedProgramaProduccionSimulacion.recalcularMateriales}"
                            oncomplete="alert('se procesaron los materiales')" reRender="dataFormula" />
      
        <h:commandButton action="#{ManagedProgramaProduccionSimulacion.aprobarProgramaProduccion_action}" value="Generar Programa Produccion" styleClass="btn" />
        </div>


        <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>
            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="200" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
           </rich:modalPanel>



           
        

        
        <br>
        
        

        
        <div align="center" style="visibility:hidden; " id="contenido"  >
            
            
            
            
            
            
            <p>Cargando.....</p>  
            <img src="../img/load.gif" valign="center" > 
        </div>
        
    </div>
    <!--cerrando la conexion-->
    <h:outputText value="#{ManagedProgramaProduccionSimulacion.closeConnection}"  />
    </a4j:form>

<rich:modalPanel id="PanelMaterialConflicto" minHeight="400"  minWidth="550"
                                     height="400" width="550"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Material que se encuentra en conflicto"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoMaterialConflicto">
                            <h:panelGrid>
                            <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.materialesConflictoList}"
                                    var="data"
                                    id="dataProductos"

                                    headerClass="headerClassACliente" style="margin-top:12px;">
                                 <f:facet name="header">
                                     <rich:columnGroup>
                                         <rich:column>
                                             <h:outputText value="Material"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Unidad Medida"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Grupo"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Cantidad"  />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="" />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Producto" />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Tipo Programa Prod." />
                                         </rich:column>
                                         <rich:column>
                                             <h:outputText value="Cantidad" />
                                         </rich:column>

                                     </rich:columnGroup>

                                 </f:facet>
                             <rich:subTable var="subData" value="#{data.productosList}" rowKeyVar="rowkey" >

                                 <rich:column rowspan="#{data.cantidadLista}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                                 </rich:column>
                                 <rich:column rowspan="#{data.cantidadLista}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.materiales.unidadesMedida.nombreUnidadMedida}"  />
                                 </rich:column>
                                 <rich:column rowspan="#{data.cantidadLista}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.materiales.grupo.nombreGrupo}"  />
                                 </rich:column>
                                 <rich:column rowspan="#{data.cantidadLista}"  rendered="#{rowkey eq 0}">
                                                <h:outputText value="#{data.cantidad}"  />
                                                
                                 </rich:column>
                                 <rich:column>
                                     <h:selectBooleanCheckbox value="#{subData.checked}" onclick="seleccionarProducto(this)" />
                                 </rich:column>
                                 <rich:column >
                                            <h:outputText value="#{subData.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                 </rich:column>
                                 <rich:column>
                                            <h:outputText value="#{subData.programaProduccion.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                                 </rich:column>
                                 <rich:column>
                                            <h:outputText value="#{subData.cantidad}"/>
                                 </rich:column>
                             </rich:subTable>
                            </rich:dataTable>
                            </h:panelGrid>
                            
                        </h:panelGroup>
                            <div align="center">
                                <a4j:commandButton action="#{ManagedProgramaProduccionSimulacion.agregarProductosProduccion}" value="Agregar" styleClass="btn"
                                reRender="dataFormula,productosProducir" oncomplete="Richfaces.hideModalPanel('PanelMaterialConflicto')" />
                                <a4j:commandButton value="Cancelar" styleClass="btn"
                                onclick="Richfaces.hideModalPanel('PanelMaterialConflicto')" />

                            </div>
                        </a4j:form>
                        
      </rich:modalPanel>
    
</body>
</html>

</f:view>

