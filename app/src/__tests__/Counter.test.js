import { render, screen, fireEvent } from '@testing-library/react';
import Counter from '../components/Counter';

describe('Counter Component', () => {
  test('renders with initial count of 0', () => {
    render(<Counter />);
    expect(screen.getByText('0')).toBeInTheDocument();
  });

  test('increments count when + button is clicked', () => {
    render(<Counter />);
    const increaseButton = screen.getByText(/\+ Increase/i);
    fireEvent.click(increaseButton);
    expect(screen.getByText('1')).toBeInTheDocument();
  });

  test('decrements count when - button is clicked', () => {
    render(<Counter />);
    const decreaseButton = screen.getByText(/- Decrease/i);
    fireEvent.click(decreaseButton);
    expect(screen.getByText('-1')).toBeInTheDocument();
  });

  test('resets count to 0 when Reset button is clicked', () => {
    render(<Counter />);
    const increaseButton = screen.getByText(/\+ Increase/i);
    const resetButton = screen.getByText(/Reset/i);
    
    fireEvent.click(increaseButton);
    fireEvent.click(increaseButton);
    fireEvent.click(resetButton);
    
    expect(screen.getByText('0')).toBeInTheDocument();
  });
});
