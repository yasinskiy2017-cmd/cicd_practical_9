// @vitest-environment jsdom
import React from 'react';
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import App from './App.jsx';

describe('App', () => {
  it('should render successfully', () => {
    render(<App />);
    const headingElement = screen.getByText(/CI\/CD Practical 9/i);
    expect(headingElement).toBeDefined();
  });
});