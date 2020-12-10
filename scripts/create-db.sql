-- Main table to store tasks
CREATE TABLE task
(
  id serial,
  body text NOT NULL, -- Textual description of the task
  priority integer NOT NULL DEFAULT 0, -- Potentially used to sort tasks
  done boolean NOT NULL DEFAULT false, -- Is the task done?
  done_at timestamptz,
  CONSTRAINT pk_task PRIMARY KEY (id)
);
