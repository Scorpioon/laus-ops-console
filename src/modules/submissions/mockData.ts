// src/modules/submissions/mockData.ts
// Realistic mock dataset for submissions module

export interface MockSubmission {
  id: string;
  code: string;          // NN-NNNNN format
  title: string;
  category: string;
  payment: 'ok' | 'pending' | 'issue';
  material: 'ok' | 'warning' | 'issue';
  selected?: boolean;
}

export const mockSubmissions: MockSubmission[] = [
  { id: '1', code: '17-64795', title: 'Disseny exposició', category: 'Branding', payment: 'ok', material: 'warning' },
  { id: '2', code: '18-02341', title: 'Campanya gràfica', category: 'Publicitat', payment: 'pending', material: 'ok' },
  { id: '3', code: '19-11223', title: 'Web corporativa', category: 'Digital', payment: 'ok', material: 'issue' },
  { id: '4', code: '20-33456', title: 'Identitat visual', category: 'Branding', payment: 'ok', material: 'ok' },
  { id: '5', code: '21-44567', title: 'Anunci televisiu', category: 'Audiovisual', payment: 'pending', material: 'warning' },
  { id: '6', code: '22-55678', title: 'Packaging producte', category: 'Packaging', payment: 'ok', material: 'ok' },
  { id: '7', code: '23-66789', title: 'Il·lustració editorial', category: 'Editorial', payment: 'issue', material: 'ok' },
  { id: '8', code: '24-77890', title: 'Tipografia custom', category: 'Digital', payment: 'ok', material: 'warning' },
  { id: '9', code: '25-88901', title: 'Senyalització', category: 'Espai', payment: 'pending', material: 'issue' },
  { id: '10', code: '26-99012', title: 'Aplicació mòbil', category: 'Digital', payment: 'ok', material: 'ok' },
  { id: '11', code: '27-10123', title: 'Catàleg exposició', category: 'Editorial', payment: 'ok', material: 'ok' },
  { id: '12', code: '28-21234', title: 'Fotografia campanya', category: 'Fotografia', payment: 'pending', material: 'warning' },
  { id: '13', code: '29-32345', title: 'Vídeo corporatiu', category: 'Audiovisual', payment: 'ok', material: 'issue' },
  { id: '14', code: '30-43456', title: 'Eines de comunicació', category: 'Gràfic', payment: 'ok', material: 'ok' },
  { id: '15', code: '31-54567', title: 'Instal·lació artística', category: 'Espai', payment: 'issue', material: 'ok' },
  { id: '16', code: '32-65678', title: 'Disseny de producte', category: 'Producte', payment: 'pending', material: 'warning' },
  { id: '17', code: '33-76789', title: 'Interfície d\'usuari', category: 'Digital', payment: 'ok', material: 'ok' },
  { id: '18', code: '34-87890', title: 'Animació 2D', category: 'Audiovisual', payment: 'ok', material: 'issue' },
  { id: '19', code: '35-98901', title: 'Llibre d\'artista', category: 'Editorial', payment: 'pending', material: 'ok' },
  { id: '20', code: '36-09012', title: 'Estratègia de marca', category: 'Branding', payment: 'ok', material: 'ok' },
];