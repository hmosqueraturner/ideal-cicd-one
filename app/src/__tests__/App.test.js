import { render, screen } from '@testing-library/react';
import App from '../App';

describe('App Component', () => {
  test('renders ACiD Suite heading', () => {
    render(<App />);
    const headingElement = screen.getByText(/ACiD Suite/i);
    expect(headingElement).toBeInTheDocument();
  });

  test('renders all technology badges', () => {
    render(<App />);
    expect(screen.getByText('React')).toBeInTheDocument();
    expect(screen.getByText('Docker')).toBeInTheDocument();
    expect(screen.getByText('GitHub Actions')).toBeInTheDocument();
    expect(screen.getByText('Terraform')).toBeInTheDocument();
    expect(screen.getByText('Ansible')).toBeInTheDocument();
    expect(screen.getByText('Azure')).toBeInTheDocument();
  });

  test('renders feature cards', () => {
    render(<App />);
    expect(screen.getByText('Continuous Integration')).toBeInTheDocument();
    expect(screen.getByText('Containerization')).toBeInTheDocument();
    expect(screen.getByText('Code Quality')).toBeInTheDocument();
    expect(screen.getByText('Cloud Deployment')).toBeInTheDocument();
  });
});
