"""alter db

Revision ID: 3e3d318cbfb4
Revises: 32bfd116ec8d
Create Date: 2015-03-21 16:45:03.523538

"""

# revision identifiers, used by Alembic.
revision = '3e3d318cbfb4'
down_revision = '32bfd116ec8d'

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_table('lead_lead_item',
    sa.Column('lead_id', sa.Integer(), nullable=False),
    sa.Column('lead_item_id', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['lead_id'], ['lead.id'], name='fk_lead_id_lead_lead_item', onupdate='cascade', ondelete='restrict'),
    sa.ForeignKeyConstraint(['lead_item_id'], ['lead_item.id'], name='fk_lead_item_id_lead_lead_item', onupdate='cascade', ondelete='restrict'),
    sa.PrimaryKeyConstraint('lead_id', 'lead_item_id')
    )
    op.drop_table('apscheduler_jobs')
    op.drop_constraint(u'fk_lead_id_lead_item', 'lead_item', type_='foreignkey')
    op.drop_column('lead_item', 'lead_id')
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('lead_item', sa.Column('lead_id', sa.INTEGER(), autoincrement=False, nullable=False))
    op.create_foreign_key(u'fk_lead_id_lead_item', 'lead_item', 'lead', ['lead_id'], ['id'])
    op.create_table('apscheduler_jobs',
    sa.Column('id', sa.VARCHAR(length=191), autoincrement=False, nullable=False),
    sa.Column('next_run_time', postgresql.DOUBLE_PRECISION(precision=53), autoincrement=False, nullable=True),
    sa.Column('job_state', postgresql.BYTEA(), autoincrement=False, nullable=False),
    sa.PrimaryKeyConstraint('id', name=u'apscheduler_jobs_pkey')
    )
    op.drop_table('lead_lead_item')
    ### end Alembic commands ###
