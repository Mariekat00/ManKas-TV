"use client";

import { Component, type ReactNode } from "react";

type Props = {
  children: ReactNode;
  fallback?: ReactNode;
};

type State = {
  hasError: boolean;
  error: Error | null;
};

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      return (
        this.props.fallback ?? (
          <div className="flex min-h-48 items-center justify-center">
            <div className="rounded-md border border-red-500/30 bg-red-950/80 p-6 text-center">
              <p className="text-sm text-red-100">Something went wrong.</p>
              <button
                type="button"
                onClick={() => this.setState({ hasError: false, error: null })}
                className="mt-3 rounded-md bg-accent px-4 py-2 text-xs font-medium text-white"
              >
                Try again
              </button>
            </div>
          </div>
        )
      );
    }
    return this.props.children;
  }
}
