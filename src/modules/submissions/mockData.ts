// src/modules/submissions/mockData.ts
// Realistic mock dataset for submissions module

export interface MockSubmission {
  id: string;
  code: string;          // NN/NNNNN format (e.g., 17/64795)
  title: string;
  category: string;
  payment: 'ok' | 'pending' | 'issue';
  material: 'ok' | 'warning' | 'issue';
  selected?: boolean;
  // Contact info
  firstName: string;
  lastName: string;
  email: string;
  studio: string;        // studio/agency/freelance
  phone?: string;
  website?: string;
  fadMember: boolean;
  associationMember: boolean;
  otherSubmissions: string[]; // codes of other submissions by same contact
  // Internal notes
  internalNotes?: string;
  // Links
  projectUrl?: string;
  dropboxUrl?: string;
}

export const mockSubmissions: MockSubmission[] = [
  { id: '1', code: '17/64795', title: 'Disseny exposiciÃƒÂ³', category: 'Branding', payment: 'ok', material: 'warning',
    firstName: 'Anna', lastName: 'Puig', email: 'anna@estudi.com', studio: 'Estudi Anna Puig', phone: '934567890', website: 'https://annapuig.cat',
    fadMember: true, associationMember: false, otherSubmissions: ['18/02341', '20/33456'],
    internalNotes: 'Pendent d\'aprovaciÃƒÂ³ final', projectUrl: 'https://projecte1.com', dropboxUrl: 'https://dropbox.com/1' },
  { id: '2', code: '18/02341', title: 'Campanya grÃƒÂ fica', category: 'Publicitat', payment: 'pending', material: 'ok',
    firstName: 'Joan', lastName: 'Vidal', email: 'joan@agencia.cat', studio: 'Agencia Vidal', phone: '934567891', website: 'https://vidal.cat',
    fadMember: false, associationMember: true, otherSubmissions: ['17/64795'],
    internalNotes: 'RevisiÃƒÂ³ de proofs', projectUrl: 'https://campanya2.com', dropboxUrl: 'https://dropbox.com/2' },
  { id: '3', code: '19/11223', title: 'Web corporativa', category: 'Digital', payment: 'ok', material: 'issue',
    firstName: 'Marta', lastName: 'Soler', email: 'marta@web.cat', studio: 'Web Soler', phone: '934567892', website: 'https://marta.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Falten continguts', projectUrl: 'https://web3.com', dropboxUrl: 'https://dropbox.com/3' },
  { id: '4', code: '20/33456', title: 'Identitat visual', category: 'Branding', payment: 'ok', material: 'ok',
    firstName: 'Pau', lastName: 'Roca', email: 'pau@estudi.com', studio: 'Estudi Roca', phone: '934567893', website: 'https://pauroca.com',
    fadMember: false, associationMember: false, otherSubmissions: ['17/64795'],
    internalNotes: 'Lliurat', projectUrl: 'https://identitat4.com', dropboxUrl: 'https://dropbox.com/4' },
  { id: '5', code: '21/44567', title: 'Anunci televisiu', category: 'Audiovisual', payment: 'pending', material: 'warning',
    firstName: 'Laia', lastName: 'Font', email: 'laia@tv.cat', studio: 'TV Font', phone: '934567894', website: 'https://laiafont.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Pendent de pagament', projectUrl: 'https://spot5.com', dropboxUrl: 'https://dropbox.com/5' },
  { id: '6', code: '22/55678', title: 'Packaging producte', category: 'Packaging', payment: 'ok', material: 'ok',
    firstName: 'Carles', lastName: 'Mas', email: 'carles@pack.cat', studio: 'Pack Mas', phone: '934567895', website: 'https://carlesmas.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'A punt per enviar', projectUrl: 'https://pack6.com', dropboxUrl: 'https://dropbox.com/6' },
  { id: '7', code: '23/66789', title: 'IlÃ‚Â·lustraciÃƒÂ³ editorial', category: 'Editorial', payment: 'issue', material: 'ok',
    firstName: 'Laura', lastName: 'Estrany', email: 'laura@ilÃ‚Â·lustra.cat', studio: 'IlÃ‚Â·lustra Laura', phone: '934567896', website: 'https://laura.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'ReclamaciÃƒÂ³ pendent', projectUrl: 'https://ilÃ‚Â·lustra7.com', dropboxUrl: 'https://dropbox.com/7' },
  { id: '8', code: '24/77890', title: 'Tipografia custom', category: 'Digital', payment: 'ok', material: 'warning',
    firstName: 'Gerard', lastName: 'Font', email: 'gerard@tipografia.com', studio: 'Tipografia Font', phone: '934567897', website: 'https://gerardfont.com',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'LlicÃƒÂ¨ncia per revisar', projectUrl: 'https://font8.com', dropboxUrl: 'https://dropbox.com/8' },
  { id: '9', code: '25/88901', title: 'SenyalitzaciÃƒÂ³', category: 'Espai', payment: 'pending', material: 'issue',
    firstName: 'Cristina', lastName: 'Pla', email: 'cristina@senyal.cat', studio: 'Senyal Pla', phone: '934567898', website: 'https://cristinapla.cat',
    fadMember: false, associationMember: true, otherSubmissions: [],
    internalNotes: 'Material no rebut', projectUrl: 'https://senyal9.com', dropboxUrl: 'https://dropbox.com/9' },
  { id: '10', code: '26/99012', title: 'AplicaciÃƒÂ³ mÃƒÂ²bil', category: 'Digital', payment: 'ok', material: 'ok',
    firstName: 'Albert', lastName: 'Rius', email: 'albert@app.cat', studio: 'App Rius', phone: '934567899', website: 'https://albertrius.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Publicada', projectUrl: 'https://app10.com', dropboxUrl: 'https://dropbox.com/10' },
  { id: '11', code: '27/10123', title: 'CatÃƒÂ leg exposiciÃƒÂ³', category: 'Editorial', payment: 'ok', material: 'ok',
    firstName: 'NÃƒÂºria', lastName: 'Valls', email: 'nuria@cataleg.cat', studio: 'CatÃƒÂ leg Valls', phone: '934567800', website: 'https://nuriavalls.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Enviat a impremta', projectUrl: 'https://cataleg11.com', dropboxUrl: 'https://dropbox.com/11' },
  { id: '12', code: '28/21234', title: 'Fotografia campanya', category: 'Fotografia', payment: 'pending', material: 'warning',
    firstName: 'Toni', lastName: 'Mir', email: 'toni@foto.cat', studio: 'Foto Mir', phone: '934567801', website: 'https://tonimir.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'Esperant selecciÃƒÂ³', projectUrl: 'https://foto12.com', dropboxUrl: 'https://dropbox.com/12' },
  { id: '13', code: '29/32345', title: 'VÃƒÂ­deo corporatiu', category: 'Audiovisual', payment: 'ok', material: 'issue',
    firstName: 'SÃƒÂ­lvia', lastName: 'Grau', email: 'silvia@video.cat', studio: 'Video Grau', phone: '934567802', website: 'https://silviagrau.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Falta llicÃƒÂ¨ncia mÃƒÂºsica', projectUrl: 'https://video13.com', dropboxUrl: 'https://dropbox.com/13' },
  { id: '14', code: '30/43456', title: 'Eines de comunicaciÃƒÂ³', category: 'GrÃƒÂ fic', payment: 'ok', material: 'ok',
    firstName: 'Oriol', lastName: 'Cases', email: 'oriol@eines.cat', studio: 'Eines Cases', phone: '934567803', website: 'https://oriolcases.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Material complet', projectUrl: 'https://eines14.com', dropboxUrl: 'https://dropbox.com/14' },
  { id: '15', code: '31/54567', title: 'InstalÃ‚Â·laciÃƒÂ³ artÃƒÂ­stica', category: 'Espai', payment: 'issue', material: 'ok',
    firstName: 'MÃƒÂ²nica', lastName: 'Serra', email: 'monica@instalÃ‚Â·lacio.cat', studio: 'InstalÃ‚Â·laciÃƒÂ³ Serra', phone: '934567804', website: 'https://monicaserra.cat',
    fadMember: false, associationMember: true, otherSubmissions: [],
    internalNotes: 'Esperant confirmaciÃƒÂ³', projectUrl: 'https://instalÃ‚Â·lacio15.com', dropboxUrl: 'https://dropbox.com/15' },
  { id: '16', code: '32/65678', title: 'Disseny de producte', category: 'Producte', payment: 'pending', material: 'warning',
    firstName: 'Ramon', lastName: 'Coll', email: 'ramon@producte.cat', studio: 'Producte Coll', phone: '934567805', website: 'https://ramoncoll.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Prototip en revisiÃƒÂ³', projectUrl: 'https://producte16.com', dropboxUrl: 'https://dropbox.com/16' },
  { id: '17', code: '33/76789', title: 'InterfÃƒÂ­cie d\'usuari', category: 'Digital', payment: 'ok', material: 'ok',
    firstName: 'Helena', lastName: 'Bosch', email: 'helena@ui.cat', studio: 'UI Bosch', phone: '934567806', website: 'https://helenabosch.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Entregat', projectUrl: 'https://ui17.com', dropboxUrl: 'https://dropbox.com/17' },
  { id: '18', code: '34/87890', title: 'AnimaciÃƒÂ³ 2D', category: 'Audiovisual', payment: 'ok', material: 'issue',
    firstName: 'David', lastName: 'Parra', email: 'david@animacio.cat', studio: 'AnimaciÃƒÂ³ Parra', phone: '934567807', website: 'https://davidparra.cat',
    fadMember: false, associationMember: false, otherSubmissions: [],
    internalNotes: 'Revisar format', projectUrl: 'https://animacio18.com', dropboxUrl: 'https://dropbox.com/18' },
  { id: '19', code: '35/98901', title: 'Llibre d\'artista', category: 'Editorial', payment: 'pending', material: 'ok',
    firstName: 'Carme', lastName: 'Roca', email: 'carme@llibre.cat', studio: 'Llibre Roca', phone: '934567808', website: 'https://carmeroca.cat',
    fadMember: true, associationMember: true, otherSubmissions: [],
    internalNotes: 'Pendent de distribuciÃƒÂ³', projectUrl: 'https://llibre19.com', dropboxUrl: 'https://dropbox.com/19' },
  { id: '20', code: '36/09012', title: 'EstratÃƒÂ¨gia de marca', category: 'Branding', payment: 'ok', material: 'ok',
    firstName: 'Jordi', lastName: 'SolÃƒÂ ', email: 'jordi@marca.cat', studio: 'Marca SolÃƒÂ ', phone: '934567809', website: 'https://jordisola.cat',
    fadMember: true, associationMember: false, otherSubmissions: [],
    internalNotes: 'Complet', projectUrl: 'https://marca20.com', dropboxUrl: 'https://dropbox.com/20' },
];
