// src/modules/submissions/mockData.ts - v0.4.3c
// Full canonical spreadsheet simulation. 23 fields per submission.

export interface MockSubmission {
  // -- Core identity --
  id: string
  ordre: number              // Ordre inscripcio
  code: string               // Inscripcion
  title: string              // Titulo
  category: string           // Categoria
  platform?: string          // Plataforma
  // -- Materials --
  material: 'ok' | 'warning' | 'issue'  // Material fisico recibido
  physicalMatDesc?: string               // Descripcio material fisic
  digitalMat?: 'ok' | 'warning' | 'issue'  // Material digital recibido
  digitalMatDesc?: string                   // Descripcio material digital
  // -- Project --
  projectUrl?: string        // URL proyecto
  dropboxUrl?: string        // Link Dropbox
  returnMaterial?: boolean   // Retorn de material
  projectSelected?: boolean  // Proyecto seleccionado
  award?: string             // Premio (canonical)
  // -- Contact --
  firstName: string          // Nombre
  lastName: string           // Apellidos
  email: string              // Email
  phone?: string             // Telefono
  studio?: string            // studio / agency (derived context)
  website?: string           // website
  fadMember: boolean         // Miembro FAD
  associationMember: boolean // Miembro otras assoc.
  // -- Payment --
  payment: 'ok' | 'pending' | 'issue'  // Pago confirmado
  price?: string             // Precio inscripcion
  year: number               // Anno
  // -- UI helpers --
  otherSubmissions: string[]
  internalNotes?: string
}

export const mockSubmissions: MockSubmission[] = [
  {
    id:'1', ordre:1, code:'17/64795', title:'Disseny exposici\u00f3', category:'Branding',
    platform:'Impremta', material:'warning', physicalMatDesc:'Rollup 200\u00d780cm',
    digitalMat:'ok', digitalMatDesc:'PDF alta qualitat',
    projectUrl:'https://projecte1.com', dropboxUrl:'https://dropbox.com/1',
    returnMaterial:false, projectSelected:true, award:'',
    firstName:'Anna', lastName:'Puig', email:'anna@estudi.com',
    studio:'Estudi Anna Puig', phone:'934567890', website:'https://annapuig.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:['18/02341','20/33456'],
    internalNotes:"Pendent d'aprovaci\u00f3 final",
  },
  {
    id:'2', ordre:2, code:'18/02341', title:'Campanya gr\u00e0fica', category:'Publicitat',
    platform:'Impremta', material:'ok', physicalMatDesc:'3 p\u00f2sters A1',
    digitalMat:'ok', digitalMatDesc:'Arxius InDesign',
    projectUrl:'https://campanya2.com', dropboxUrl:'https://dropbox.com/2',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Joan', lastName:'Vidal', email:'joan@agencia.cat',
    studio:'Agencia Vidal', phone:'934567891', website:'https://vidal.cat',
    fadMember:false, associationMember:true,
    payment:'pending', price:'145', year:2024,
    otherSubmissions:['17/64795'],
    internalNotes:'Revis\u00ed\u00f3 de proofs',
  },
  {
    id:'3', ordre:3, code:'19/11223', title:'Web corporativa', category:'Digital',
    platform:'Web', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'Fitxers incomplets',
    projectUrl:'https://web3.com', dropboxUrl:'https://dropbox.com/3',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Marta', lastName:'Soler', email:'marta@web.cat',
    studio:'Web Soler', phone:'934567892', website:'https://marta.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Falten continguts',
  },
  {
    id:'4', ordre:4, code:'20/33456', title:'Identitat visual', category:'Branding',
    platform:'Impremta', material:'ok', physicalMatDesc:'Manual de marca + aplicacions',
    digitalMat:'ok', digitalMatDesc:'Guies editables AI/PDF',
    projectUrl:'https://identitat4.com', dropboxUrl:'https://dropbox.com/4',
    returnMaterial:true, projectSelected:true, award:'inBook',
    firstName:'Pau', lastName:'Roca', email:'pau@estudi.com',
    studio:'Estudi Roca', phone:'934567893', website:'https://pauroca.com',
    fadMember:false, associationMember:false,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:['17/64795'],
    internalNotes:'Lliurat. inBook 2024.',
  },
  {
    id:'5', ordre:5, code:'21/44567', title:'Anunci televisiu', category:'Audiovisual',
    platform:'Audiovisual', material:'warning', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'V\u00eddeo pendent de masteritzar',
    projectUrl:'https://spot5.com', dropboxUrl:'https://dropbox.com/5',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Laia', lastName:'Font', email:'laia@tv.cat',
    studio:'TV Font', phone:'934567894', website:'https://laiafont.cat',
    fadMember:true, associationMember:false,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Pendent de pagament',
  },
  {
    id:'6', ordre:6, code:'22/55678', title:'Packaging producte', category:'Packaging',
    platform:'Impremta', material:'ok', physicalMatDesc:'5 unitats + mostra material',
    digitalMat:'ok', digitalMatDesc:'Fitxers de producci\u00f3',
    projectUrl:'https://pack6.com', dropboxUrl:'https://dropbox.com/6',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Carles', lastName:'Mas', email:'carles@pack.cat',
    studio:'Pack Mas', phone:'934567895', website:'https://carlesmas.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'A punt per enviar',
  },
  {
    id:'7', ordre:7, code:'23/66789', title:'Il\u00b7lustraci\u00f3 editorial', category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'Llibre original + reproductions',
    digitalMat:'ok', digitalMatDesc:'Alta resoluci\u00f3 300dpi',
    projectUrl:'https://illustra7.com', dropboxUrl:'https://dropbox.com/7',
    returnMaterial:true, projectSelected:true, award:'Bronce',
    firstName:'Laura', lastName:'Estrany', email:'laura@illustra.cat',
    studio:"Il\u00b7lustra Laura", phone:'934567896', website:'https://laura.cat',
    fadMember:false, associationMember:false,
    payment:'issue', price:'145', year:2024,
    otherSubmissions:[],
    internalNotes:'Reclamaci\u00f3 pendent. Premi bronce confirmat.',
  },
  {
    id:'8', ordre:8, code:'24/77890', title:'Tipografia custom', category:'Digital',
    platform:'Web', material:'warning', physicalMatDesc:'Specimen impr\u00e8s A5',
    digitalMat:'ok', digitalMatDesc:'Font files OTF/TTF + specimen PDF',
    projectUrl:'https://font8.com', dropboxUrl:'https://dropbox.com/8',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Gerard', lastName:'Font', email:'gerard@tipografia.com',
    studio:'Tipografia Font', phone:'934567897', website:'https://gerardfont.com',
    fadMember:true, associationMember:true,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Llic\u00e8ncia per revisar',
  },
  {
    id:'9', ordre:9, code:'25/88901', title:'Senyalitzaci\u00f3', category:'Espai',
    platform:'Espai', material:'issue', physicalMatDesc:'Material no rebut',
    digitalMat:'issue', digitalMatDesc:'Fitxers no enviats',
    projectUrl:'https://senyal9.com', dropboxUrl:'https://dropbox.com/9',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Cristina', lastName:'Pla', email:'cristina@senyal.cat',
    studio:'Senyal Pla', phone:'934567898', website:'https://cristinapla.cat',
    fadMember:false, associationMember:true,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Material no rebut',
  },
  {
    id:'10', ordre:10, code:'26/99012', title:'Aplicaci\u00f3 m\u00f2bil', category:'Digital',
    platform:'Digital', material:'ok', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'APK + captures de pantalla',
    projectUrl:'https://app10.com', dropboxUrl:'https://dropbox.com/10',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Albert', lastName:'Rius', email:'albert@app.cat',
    studio:'App Rius', phone:'934567899', website:'https://albertrius.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Publicada',
  },
  {
    id:'11', ordre:11, code:'27/10123', title:'Cat\u00e0leg exposici\u00f3', category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'2 cat\u00e0legs + dossier premsa',
    digitalMat:'ok', digitalMatDesc:'InDesign + PDF impremta',
    projectUrl:'https://cataleg11.com', dropboxUrl:'https://dropbox.com/11',
    returnMaterial:true, projectSelected:true, award:'Plata',
    firstName:'N\u00faria', lastName:'Valls', email:'nuria@cataleg.cat',
    studio:'Cat\u00e0leg Valls', phone:'934567800', website:'https://nuriavalls.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Enviat a impremta. Plata 2024.',
  },
  {
    id:'12', ordre:12, code:'28/21234', title:'Fotografia campanya', category:'Fotografia',
    platform:'Digital', material:'warning', physicalMatDesc:'Proofs pendent',
    digitalMat:'warning', digitalMatDesc:'Arxius RAW pendent de selecci\u00f3',
    projectUrl:'https://foto12.com', dropboxUrl:'https://dropbox.com/12',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Toni', lastName:'Mir', email:'toni@foto.cat',
    studio:'Foto Mir', phone:'934567801', website:'https://tonimir.cat',
    fadMember:false, associationMember:false,
    payment:'pending', price:'145', year:2023,
    otherSubmissions:[],
    internalNotes:'Esperant selecci\u00f3',
  },
  {
    id:'13', ordre:13, code:'29/32345', title:'V\u00eddeo corporatiu', category:'Audiovisual',
    platform:'Audiovisual', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'ProRes 4K + subtitles',
    projectUrl:'https://video13.com', dropboxUrl:'https://dropbox.com/13',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'S\u00edlvia', lastName:'Grau', email:'silvia@video.cat',
    studio:'Video Grau', phone:'934567802', website:'https://silviagrau.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Falta llic\u00e8ncia m\u00fasica',
  },
  {
    id:'14', ordre:14, code:'30/43456', title:'Eines de comunicaci\u00f3', category:'Gr\u00e0fic',
    platform:'Impremta', material:'ok', physicalMatDesc:'Carpeta amb set de peces',
    digitalMat:'ok', digitalMatDesc:'Arxius editorials complets',
    projectUrl:'https://eines14.com', dropboxUrl:'https://dropbox.com/14',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Oriol', lastName:'Cases', email:'oriol@eines.cat',
    studio:'Eines Cases', phone:'934567803', website:'https://oriolcases.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'195', year:2024,
    otherSubmissions:[],
    internalNotes:'Material complet',
  },
  {
    id:'15', ordre:15, code:'31/54567', title:"Instal\u00b7laci\u00f3 art\u00edstica", category:'Espai',
    platform:'Espai', material:'ok', physicalMatDesc:'Documentaci\u00f3 t\u00e8cnica + maqueta',
    digitalMat:'ok', digitalMatDesc:'V\u00eddeo documentaci\u00f3 + plantes',
    projectUrl:'https://installacio15.com', dropboxUrl:'https://dropbox.com/15',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'M\u00f2nica', lastName:'Serra', email:'monica@installacio.cat',
    studio:"Instal\u00b7laci\u00f3 Serra", phone:'934567804', website:'https://monicaserra.cat',
    fadMember:false, associationMember:true,
    payment:'issue', price:'545', year:2025,
    otherSubmissions:[],
    internalNotes:'Esperant confirmaci\u00f3',
  },
  {
    id:'16', ordre:16, code:'32/65678', title:'Disseny de producte', category:'Producte',
    platform:'Producte', material:'warning', physicalMatDesc:'Prototip en revisi\u00f3',
    digitalMat:'ok', digitalMatDesc:'CAD + renders 3D',
    projectUrl:'https://producte16.com', dropboxUrl:'https://dropbox.com/16',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Ramon', lastName:'Coll', email:'ramon@producte.cat',
    studio:'Producte Coll', phone:'934567805', website:'https://ramoncoll.cat',
    fadMember:true, associationMember:false,
    payment:'pending', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Prototip en revisi\u00f3',
  },
  {
    id:'17', ordre:17, code:'33/76789', title:"Interf\u00edcie d'usuari", category:'Digital',
    platform:'Web', material:'ok', physicalMatDesc:'n/a',
    digitalMat:'ok', digitalMatDesc:'Figma + prototip interactiu',
    projectUrl:'https://ui17.com', dropboxUrl:'https://dropbox.com/17',
    returnMaterial:true, projectSelected:true, award:'Grand Laus',
    firstName:'Helena', lastName:'Bosch', email:'helena@ui.cat',
    studio:'UI Bosch', phone:'934567806', website:'https://helenabosch.cat',
    fadMember:true, associationMember:true,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Grand Laus 2024.',
  },
  {
    id:'18', ordre:18, code:'34/87890', title:'Animaci\u00f3 2D', category:'Audiovisual',
    platform:'Audiovisual', material:'issue', physicalMatDesc:'n/a',
    digitalMat:'warning', digitalMatDesc:'Format incorrecte, pendent',
    projectUrl:'https://animacio18.com', dropboxUrl:'https://dropbox.com/18',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'David', lastName:'Parra', email:'david@animacio.cat',
    studio:'Animaci\u00f3 Parra', phone:'934567807', website:'https://davidparra.cat',
    fadMember:false, associationMember:false,
    payment:'ok', price:'395', year:2024,
    otherSubmissions:[],
    internalNotes:'Revisar format',
  },
  {
    id:'19', ordre:19, code:'35/98901', title:"Llibre d'artista", category:'Editorial',
    platform:'Impremta', material:'ok', physicalMatDesc:'Exemplar original + CD',
    digitalMat:'ok', digitalMatDesc:'PDF editorial + imatges',
    projectUrl:'https://llibre19.com', dropboxUrl:'https://dropbox.com/19',
    returnMaterial:false, projectSelected:false, award:'',
    firstName:'Carme', lastName:'Roca', email:'carme@llibre.cat',
    studio:"Llibre Roca", phone:'934567808', website:'https://carmeroca.cat',
    fadMember:true, associationMember:true,
    payment:'pending', price:'195', year:2023,
    otherSubmissions:[],
    internalNotes:'Pendent de distribuci\u00f3',
  },
  {
    id:'20', ordre:20, code:'36/09012', title:"Estrat\u00e8gia de marca", category:'Branding',
    platform:'Digital', material:'ok', physicalMatDesc:'Dossier estratÃ¨gic impr\u00e8s',
    digitalMat:'ok', digitalMatDesc:'Presentaci\u00f3 + manuals PDF',
    projectUrl:'https://marca20.com', dropboxUrl:'https://dropbox.com/20',
    returnMaterial:true, projectSelected:true, award:'',
    firstName:'Jordi', lastName:'Sol\u00e0', email:'jordi@marca.cat',
    studio:'Marca Sol\u00e0', phone:'934567809', website:'https://jordisola.cat',
    fadMember:true, associationMember:false,
    payment:'ok', price:'295', year:2024,
    otherSubmissions:[],
    internalNotes:'Complet',
  },
]