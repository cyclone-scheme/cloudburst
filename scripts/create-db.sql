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

-- Load sample data
INSERT INTO task (body, priority, done, done_at)
     VALUES ('Allocate too many objects', -1, true, now());
INSERT INTO task (body, priority, done, done_at) 
     VALUES ('Swap mark colors', 0, false, null);
INSERT INTO task (body, priority, done, done_at) 
     VALUES ('Mark root objects', 0, false, null);
INSERT INTO task (body) 
     VALUES ('Trace live objects');
INSERT INTO task (body)
     VALUES ('Take out the trash');
